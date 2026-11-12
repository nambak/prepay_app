<?php

use App\Models\PointLot;
use App\Models\PointUse;
use App\Models\Store;
use App\Models\User;
use App\PointUseMethod;
use Laravel\Sanctum\Sanctum;

beforeEach(function () {
    $this->travelTo('2026-11-11 12:00:00');

    $this->user = User::factory()->create();
    $this->store = Store::factory()->create(['name' => '행복식당 1']);
});

it('서비스포인트 부터, 같은 종류는 기한이 빠른 것, 먼저 충전한 것부터 빼고 쓰기 내용을 돌려준다', function () {
    $lots = PointLot::factory()->for($this->user)->for($this->store);

    $chargeA = $lots->create(['amount' => 50000, 'balance' => 50000]);
    $chargeB = $lots->create(['amount' => 50000, 'balance' => 50000]);
    $serviceLater = $lots->service()->create(['amount' => 10000, 'balance' => 10000, 'expires_on' => today()->addDays(30)]);
    $serviceSooner = $lots->service()->create(['amount' => 5000, 'balance' => 5000, 'expires_on' => today()->addDays(10)]);
    $otherStore = PointLot::factory()->for($this->user)->create(['amount' => 50000, 'balance' => 50000]);
    $otherUser = PointLot::factory()->for($this->store)->create(['amount' => 50000, 'balance' => 50000]);

    Sanctum::actingAs($this->user);

    $response = $this->postJson("/api/stores/{$this->store->id}/uses", ['amount' => 30000]);

    $balances = fn (PointLot ...$picked) => array_map(fn (PointLot $lot) => $lot->fresh()->balance, $picked);

    expect($balances($serviceSooner, $serviceLater, $chargeA, $chargeB))->toBe([0, 0, 35000, 50000])
        ->and($balances($otherStore, $otherUser))->toBe([50000, 50000]);

    $use = PointUse::sole();

    expect($use)
        ->user_id->toBe($this->user->id)
        ->store_id->toBe($this->store->id)
        ->method->toBe(PointUseMethod::Customer)
        ->amount->toBe(30000);

    expect($use->lots->mapWithKeys(fn (PointLot $lot) => [$lot->id => $lot->pivot->amount])->all())
        ->toEqual([
            $chargeA->id => 15000,
            $serviceLater->id => 10000,
            $serviceSooner->id => 5000,
        ]);

    $response->assertCreated()->assertExactJson([
        'id' => $use->id,
        'store_name' => '행복식당 1',
        'amount' => 30000,
        'service_amount' => 15000,
        'charge_amount' => 15000,
        'balance' => 85000,
        'visit_count' => 1,
        'used_at' => '2026-11-11T12:00:00+09:00',
    ]);
});

it('1P보다 적거나 쓸 수 있는 포인트보다 많으면 차감하지 않는다', function () {
    $lot = PointLot::factory()
        ->for($this->user)
        ->for($this->store)
        ->create(['amount' => 50000, 'balance' => 50000]);

    Sanctum::actingAs($this->user);

    $use = fn (mixed $amount) => $this->postJson("/api/stores/{$this->store->id}/uses", compact('amount'));

    foreach ([0, -1, 'abc', 100.5, 50001] as $amount) {
        $use($amount)->assertJsonValidationErrors('amount');
    }

    expect($lot->fresh()->balance)->toBe(50000)
        ->and(PointUse::count())->toBe(0);

    $use(50000)->assertCreated();
    expect($lot->fresh()->balance)->toBe(0)
        ->and(PointUse::count())->toBe(1);
});

it('기한이 오늘인 서비스포인트는 쓰고, 지난 것은 쓸 수 있는 포인트에 넣지 않는다', function () {
    $lots = PointLot::factory()
        ->for($this->user)
        ->for($this->store)
        ->service();
    $today = $lots->create(['expires_on' => today()]);
    $expired = $lots->expired()->create();

    Sanctum::actingAs($this->user);

    $use = fn (int $amount) => $this->postJson("/api/stores/{$this->store->id}/uses", compact('amount'));
    $use(10001)->assertJsonValidationErrors('amount');
    $use(10000)->assertCreated();

    expect($today->fresh()->balance)->toBe(0)
        ->and($expired->fresh()->balance)->toBe(10000);
});

it('로그인하지 않으면 쓸 수 없다', function () {
    $this->postJson("/api/stores/{$this->store->id}/uses", ['amount' => 1000])->assertUnauthorized();
});
