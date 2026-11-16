<?php

use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;

beforeEach(function () {
    $this->travelTo('2026-12-15 12:00:00');

    $this->user = User::factory()->create();
    $this->store = Store::factory()->create(['name' => '행복식당 1']);
});

it('결제 내역은 고른 달의 내 충전만 최신 순으로 돌려준다', function () {
    $charges = PointLot::factory()->for($this->user)->for($this->store);

    // 11월 바로 앞뒤 1초는 빠진다
    $charges->create(['created_at' => '2026-10-31 23:59:59']);
    $first = $charges->create([
        'amount' => 50000,
        'balance' => 50000,
        'paid_won' => 47500,
        'created_at' => '2026-11-01 00:00:00',
    ]);
    $last = $charges->create(['created_at' => '2026-11-30 23:59:59']);
    $charges->create(['created_at' => '2026-12-01 00:00:00']);

    // 서비스포인트와 다른 회원의 충전도 빠진다
    $charges->service()->create(['created_at' => '2026-11-15 12:00:00']);
    PointLot::factory()->for($this->store)->create(['created_at' => '2026-11-15 12:00:00']);

    Sanctum::actingAs($this->user);

    $this->getJson('/api/history/charges?year=2026&month=11')
        ->assertOk()
        ->assertExactJson([
            'balance' => 350000,
            'items' => [
                [
                    'id' => $last->id,
                    'store_id' => $this->store->id,
                    'store_name' => '행복식당 1',
                    'amount' => 100000,
                    'paid_won' => 80000,
                    'charged_at' => '2026-11-30T23:59:59+09:00',
                ],
                [
                    'id' => $first->id,
                    'store_id' => $this->store->id,
                    'store_name' => '행복식당 1',
                    'amount' => 50000,
                    'paid_won' => 47500,
                    'charged_at' => '2026-11-01T00:00:00+09:00',
                ],
            ],
        ]);

    // 잔액은 지갑의 충전포인트와 같다
    expect($this->getJson('/api/wallet')->json('charge'))->toBe(350000);
});

it('month를 빼면 그 해 전채를 돌려준다', function () {
    $charges = PointLot::factory()->for($this->user)->for($this->store);

    $charges->create(['created_at' => '2025-12-31 23:59:59']);
    $january = $charges->create(['created_at' => '2026-01-01 00:00:00']);
    $december = $charges->create(['created_at' => '2026-12-01 00:00:00']);

    Sanctum::actingAs($this->user);

    expect($this->getJson('/api/history/charges?year=2026')->assertOk()->json('items.*.id'))
        ->toBe([$december->id, $january->id]);
});

it('가게 이용 내역은 몇 번째 이용인지와 종류별로 뺀 포인트를 돌려준다', function () {
    $cafe = Store::factory()->create(['name' => '하루카페2']);
    $stranger = User::factory()->create();

    PointLot::factory()->for($this->user)->for($this->store)->create(['amount' => 100000, 'balance' => 100000, 'created_at' => '2026-10-01']);
    PointLot::factory()->for($this->user)->for($this->store)->service()->create(['amount' => 10000, 'balance' => 10000, 'created_at' => '2026-10-01']);
    PointLot::factory()->for($this->user)->for($cafe)->create(['amount' => 50000, 'balance' => 50000, 'created_at' => '2026-10-01']);
    PointLot::factory()->for($stranger)->for($this->store)->create(['created_at' => '2026-10-01']);

    // 쓴 시각마다 시간을 옮겨 가며 쓴다.
    $useAt = function (string $time, User $user, Store $store, int $amount) {
        $this->travelTo($time);

        return $user->usePoints($store, $amount);
    };

    $useAt('2026-10-20 12:00:00', $this->user, $this->store, 5000);              // 1번째, 서비스포인트에서
    $second = $useAt('2026-11-03 12:00:00', $this->user, $this->store, 30000);   // 2번째, 서비스 5,000 + 충전 25,000
    $atCafe = $useAt('2026-11-05 09:40:00', $this->user, $cafe, 6500);           // 카페 1번째
    $useAt('2026-11-10 12:00:00', $stranger, $this->store, 1000);               // 다른 회원

    $this->travelTo('2026-12-15 12:00:00');
    Sanctum::actingAs($this->user);

    $this->getJson('/api/history/uses?year=2026&month=11')
        ->assertOk()
        ->assertExactJson([
            'balance' => 118500,
            'items' => [
                [
                    'id' => $atCafe->id,
                    'store_id' => $cafe->id,
                    'store_name' => '하루카페2',
                    'visit_number' => 1,
                    'method' => 'customer',
                    'amount' => 6500,
                    'charge_amount' => 6500,
                    'shared_amount' => 0,
                    'service_amount' => 0,
                    'used_at' => '2026-11-05T09:40:00+09:00',
                ],
                [
                    'id' => $second->id,
                    'store_id' => $this->store->id,
                    'store_name' => '행복식당 1',
                    'visit_number' => 2,
                    'method' => 'customer',
                    'amount' => 30000,
                    'charge_amount' => 25000,
                    'shared_amount' => 0,
                    'service_amount' => 5000,
                    'used_at' => '2026-11-03T12:00:00+09:00',
                ],
            ],
        ]);

    // 잔액은 지갑의 충전포인트와 같다.
    expect($this->getJson('/api/wallet')->json('charge'))->toBe(118500);
});

it('쓰기 기록이 많아도 쿼리 수는 같다', function () {
    PointLot::factory()->for($this->user)->for($this->store)->create();
    Sanctum::actingAs($this->user);

    $countQueries = function (): int {
        DB::flushQueryLog();
        DB::enableQueryLog();
        $this->getJson('/api/history/uses?year=2026&month=12')->assertOk();

        return count(DB::getQueryLog());
    };

    $this->user->usePoints($this->store, 1000);
    $withOne = $countQueries();

    foreach (range(1, 4) as $i) {
        $this->user->usePoints($this->store, 1000);
    }

    expect($this->getJson('/api/history/uses?year=2026&month=12')->json('items'))->toHaveCount(5)
        ->and($countQueries())->toBe($withOne);
});

it('기간이 틀리면 4222를 돌려준다', function (string $kind, string $query) {
    Sanctum::actingAs($this->user);

    $this->getJson("/api/history/{$kind}?{$query}")->assertUnprocessable();
})->with(['charges', 'uses'])->with(['', 'year=26', 'year=abcd', 'year=2026&month=0', 'year=2026&month=13']);

it('로그인하지 않으면 401을 돌려준다', function (string $kind) {
    $this->getJson("/api/history/{$kind}?year=2026&month=11")->assertUnauthorized();
})->with(['charges', 'uses']);
