<?php

use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use App\PointType;
use Laravel\Sanctum\Sanctum;

beforeEach(function () {
    $this->travelTo('2026-11-09 14:03:00');
});

it('고른 충전 상품만큼 충전포인트 묶음을 하나 만들고 충전 내용을 돌려준다', function () {
    $user = User::factory()->create();
    $store = Store::factory()->create(['name' => '하루카페']);
    [$small, $large] = $store->chargeProducts()->createMany([
        ['amount' => 50000, 'price_won' => 47500],
        ['amount' => 100000, 'price_won' => 90000],
    ]);

    Sanctum::actingAs($user);

    $response = $this->postJson("/api/stores/{$store->id}/charges", ['items' => [
        ['charge_product_id' => $small->id, 'quantity' => 1],
        ['charge_product_id' => $large->id, 'quantity' => 2],
    ]]);

    $lot = PointLot::sole();

    expect($lot)
        ->user_id->toBe($user->id)
        ->store_id->toBe($store->id)
        ->type->toBe(PointType::Charge)
        ->amount->toBe(250000)
        ->balance->toBe(250000)
        ->paid_won->toBe(227500)
        ->expires_on->toBeNull();

    $response->assertCreated()->assertExactJson([
        'id' => $lot->id,
        'store_name' => '하루카페',
        'amount' => 250000,
        'paid_won' => 227500,
        'charged_at' => '2026-11-09T14:03:00+09:00',
    ]);
});

it('다른 가게의 상품이나 잘못된 수량으로는 충전하지 않는다', function () {
    $store = Store::factory()->create();
    $product = $store->chargeProducts()->create(['amount' => 50000, 'price_won' => 47500]);
    $otherProduct = Store::factory()->create()->chargeProducts()->create(['amount' => 50000, 'price_won' => 40000]);

    Sanctum::actingAs(User::factory()->create());

    $charge = fn (array $items) => $this->postJson("/api/stores/{$store->id}/charges", ['items' => $items]);

    $charge([])->assertJsonValidationErrors('items');
    $charge([['charge_product_id' => $otherProduct->id, 'quantity' => 1]])
        ->assertJsonValidationErrors('items.0.charge_product_id');
    $charge([['charge_product_id' => $product->id, 'quantity' => 0]])
        ->assertJsonValidationErrors('items.0.quantity');
    $charge([['charge_product_id' => $product->id, 'quantity' => 100]])
        ->assertJsonValidationErrors('items.0.quantity');
    $charge([
        ['charge_product_id' => $product->id, 'quantity' => 1],
        ['charge_product_id' => $product->id, 'quantity' => 1],
    ])->assertJsonValidationErrors('items.1.charge_product_id');

    expect(PointLot::count())->toBe(0);
});

it('로그인하지 않으면 충전할 수 없다', function () {
    $store = Store::factory()->create();

    $this->postJson("/api/stores/{$store->id}/charges", ['items' => []])->assertUnauthorized();
});
