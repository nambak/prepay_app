<?php

use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use App\StoreKind;
use Illuminate\Database\QueryException;
use Laravel\Sanctum\Sanctum;

beforeEach(function () {
    $this->travelTo('2026-10-31 15:00:00');
});

it('쓸 수 있는 포인트만 가게별로 돌려준다', function () {
    $user = User::factory()->create();
    $restaurant = Store::factory()->create(['name' => '행복식당 1', 'kind' => StoreKind::Food]);
    $cafe = Store::factory()->create(['name' => '하루카페2', 'kind' => StoreKind::Cafe]);
    $closed = Store::factory()->create();

    PointLot::factory()->for($user)
        ->for($restaurant)
        ->create([
            'amount' => 100000,
            'balance' => 100000,
            'paid_won' => 80000,
            'created_at' => '2026-10-01',
        ]);

    PointLot::factory()->for($user)
        ->for($restaurant)
        ->service()
        ->create([
            'amount' => 30000,
            'balance' => 30000,
            'expires_on' => '2027-02-08',
            'created_at' => '2026-10-02',
        ]);

    // 다 쓴 충전: 목록에는 없지만 아낀 금액에는 들어간다.
    PointLot::factory()->for($user)
        ->for($restaurant)
        ->usedUp()
        ->create([
            'amount' => 50000,
            'paid_won' => 45000,
            'created_at' => '2026-09-01',
        ]);

    PointLot::factory()->for($user)
        ->for($cafe)
        ->create([
            'amount' => 50000,
            'balance' => 20000,
            'paid_won' => 47500,
            'created_at' => '2026-10-20',
        ]);

    // 기한이 지난 서비스 포인트만 남은 가게는 목록에서 빠진다.
    PointLot::factory()->for($user)->for($closed)->service()->expired()->create();

    // 다른 회원의 포인트
    PointLot::factory()->for($restaurant)->create();

    Sanctum::actingAs($user);

    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertExactJson([
            'charge' => 120000,
            'shared' => 0,
            'service' => 30000,
            'saved_won' => 27500,
            'stores' => [
                [
                    'id' => $cafe->id,
                    'name' => '하루카페2',
                    'kind' => 'cafe',
                    'visit_count' => 0,
                    'saved_won' => 2500,
                    'items' => [
                        ['type' => 'charge', 'amount' => 20000, 'days_left' => null],
                    ],
                ],
                [
                    'id' => $restaurant->id,
                    'name' => '행복식당 1',
                    'kind' => 'food',
                    'visit_count' => 0,
                    'saved_won' => 25000,
                    'items' => [
                        ['type' => 'charge', 'amount' => 100000, 'days_left' => null],
                        ['type' => 'service', 'amount' => 30000, 'days_left' => 100],
                    ],
                ],
            ],
        ]);
});

it('서비스 포인트는 유효기간 마지막 날까지 보여 주고 다음 날부터 뺀다', function () {
    $user = User::factory()->create();
    PointLot::factory()->for($user)->service()->create(['balance' => 10000, 'expires_on' => '2026-10-31']);
    PointLot::factory()->for($user)->service()->create(['balance' => 20000, 'expires_on' => '2026-10-30']);

    Sanctum::actingAs($user);

    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertJsonPath('service', 10000)
        ->assertJsonPath('stores.0.items', [['type' => 'service', 'amount' => 10000, 'days_left' => 0]]);
});

it('충전포인트는 기한이 없어서 오래전에 충전해도 보여 준다', function () {
    $user = User::factory()->create();
    PointLot::factory()->for($user)->create(['balance' => 10000, 'created_at' => '2020-01-01']);

    Sanctum::actingAs($user);

    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertJsonPath('charge', 10000)
        ->assertJsonPath('stores.0.items', [['type' => 'charge', 'amount' => 10000, 'days_left' => null]]);
});

it('방문 횟수는 그 가게에서 쓴 횟수다', function () {
    $user = User::factory()->create();
    $restaurant = Store::factory()->create();
    $cafe = Store::factory()->create();
    PointLot::factory()->for($user)->for($restaurant)->create(['amount' => 100000, 'balance' => 100000]);
    PointLot::factory()->for($user)->for($cafe)->create(['amount' => 100000, 'balance' => 100000]);

    $user->usePoints($restaurant, 10000);
    $user->usePoints($restaurant, 20000);

    // 다른 회원이 같은 가게에서 쓴 것은 세지 않는다.
    $other = User::factory()->create();
    PointLot::factory()->for($other)->for($restaurant)->create(['amount' => 10000, 'balance' => 10000]);
    $other->usePoints($restaurant, 10000);

    Sanctum::actingAs($user);

    $stores = $this->getJson('/api/wallet')->assertOk()->json('stores');

    expect(collect($stores)->pluck('visit_count', 'id')->all())
        ->toEqual([$restaurant->id => 2, $cafe->id => 0]);
});

it('포인트가 없으면 빈 지갑을 돌려준다', function () {
    Sanctum::actingAs(User::factory()->create());

    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertExactJson(['charge' => 0, 'shared' => 0, 'service' => 0, 'saved_won' => 0, 'stores' => []]);
});

it('포인트 기록이 있는 회원은 지울 수 없다', function () {
    $lot = PointLot::factory()->create();

    expect(fn () => $lot->user->delete())->toThrow(QueryException::class);
});
