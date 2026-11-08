<?php

use App\Models\Store;
use App\Models\User;
use App\StoreKind;
use Laravel\Sanctum\Sanctum;

it('가게 목록은 가게마다 가장 큰 할인율을 함께 준다', function () {
    $cafe = Store::factory()->create([
        'name' => '하루카페 강남점',
        'kind' => StoreKind::Cafe,
    ]);
    $cafe->chargeProducts()->createMany([
        ['amount' => 50000, 'price_won' => 47500],
        ['amount' => 100000, 'price_won' => 80000],
    ]);
    $flower = Store::factory()->create([
        'name' => '봄꽃집',
        'kind' => StoreKind::Shop,
    ]);
    Sanctum::actingAs(User::factory()->create());

    $this->getJson('/api/stores')
        ->assertOk()
        ->assertExactJson(['stores' => [
            ['id' => $cafe->id, 'name' => '하루카페 강남점', 'kind' => 'cafe', 'max_discount_rate' => 20],
            ['id' => $flower->id, 'name' => '봄꽃집', 'kind' => 'shop', 'max_discount_rate' => null],
        ]]);
});

it('가게 상세는 충전 상품을 포인트가 작은 순으로 주고, 할인율의 소수점은 버린다', function () {
    $cafe = Store::factory()->create([
        'name' => '하루카페 강남점',
        'kind' => StoreKind::Cafe,
        'address' => '서울시 행복구 행복로 123 1층',
        'phone' => '02-1234-5678',
    ]);
    $cafe->chargeProducts()->createMany([
        ['amount' => 100000, 'price_won' => 80000],
        ['amount' => 30000, 'price_won' => 27100],  // 9.66%
    ]);
    Sanctum::actingAs(User::factory()->create());

    $this->getJson("/api/stores/{$cafe->id}")
        ->assertOk()
        ->assertJson([
            'id' => $cafe->id,
            'name' => '하루카페 강남점',
            'kind' => 'cafe',
            'address' => '서울시 행복구 행복로 123 1층',
            'phone' => '02-1234-5678',
        ])
        ->assertJsonPath('charge_products.*.amount', [30000, 100000])
        ->assertJsonPath('charge_products.*.price_won', [27100, 80000])
        ->assertJsonPath('charge_products.*.discount_rate', [9, 20]);
});

it('가게 목록과 상세는 로그인해야 볼 수 있다', function () {
    $store = Store::factory()->create();

    $this->getJson('/api/stores')->assertUnauthorized();
    $this->getJson("/api/stores/{$store->id}")->assertUnauthorized();
});
