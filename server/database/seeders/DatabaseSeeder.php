<?php

namespace Database\Seeders;

use App\Models\Admin;
use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use App\StoreKind;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // 고객 앱 로그인 계정. 비밀번호는 UserFactory 기본값
        $user = User::factory()->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
        ]);

        // 관리자 웹(/admin) 로그인용. 비밀번호는 테스트의 createAdminAccount()와 같다
        Admin::create([
            'name' => '관리자',
            'email' => 'admin@example.com',
            'password' => 'password1234',
        ]);

        // 테스트 계정의 포인트. 시안 05-01·05-08과 비슷하게 넣는다.
        $restaurant = Store::factory()->create([
            'name' => '행복식당 1',
            'kind' => StoreKind::Food,
            'address' => '서울시 행복구 행복로 45',
            'phone' => '02-1234-5678'
        ]);
        $cafe = Store::factory()->create([
            'name' => '하루카페2',
            'kind' => StoreKind::Cafe,
            'address' => '서울시 행복구 하늘로 12 2층',
            'phone' => '02-2345-6789'
        ]);
        $sandwich = Store::factory()->create([
            'name' => '행복샌드위치',
            'kind' => StoreKind::Food,
            'address' => '서울시 행복구 행복로 78',
            'phone' => '02-3456-7890'
        ]);
        $flower = Store::factory()->create([
            'name' => '봄꽃집',
            'kind' => StoreKind::Shop,
            'address' => '서울시 행복구 하늘로 30',
            'phone' => '02-4567-8901'
        ]);
        // 포인트도 충전 상품도 없는 가게(가게찾기에서 할인 배지가 없는 라인)
        Store::factory()->create([
            'name' => '아침베이커리',
            'kind' => StoreKind::Bakery,
            'address' => '서울시 행복구 하늘로 5',
        ]);

        // 충전 상품. 아래 포인트 묶음의 충전 금액·낸 돈과 맞춘다.
        $restaurant->chargeProducts()->createMany([
            ['amount' => 50000, 'price_won' => 45000],
            ['amount' => 150000, 'price_won' => 127500],
        ]);
        $cafe->chargeProducts()->createMany([
            ['amount' => 50000, 'price_won' => 47500],
            ['amount' => 100000, 'price_won' => 80000],
        ]);
        $sandwich->chargeProducts()->create(['amount' => 100000, 'price_won' => 90000]);
        $flower->chargeProducts()->create(['amount' => 50000, 'price_won' => 45500]);

        PointLot::factory()->for($user)->for($restaurant)->create(['amount' => 150000, 'balance' => 150000, 'paid_won' => 127500]);
        PointLot::factory()->for($user)->for($restaurant)->service()->create(['amount' => 30000, 'balance' => 30000, 'expires_on' => today()->addYear()]);
        PointLot::factory()->for($user)->for($cafe)->create(['amount' => 100000, 'balance' => 100000, 'paid_won' => 80000]);
        PointLot::factory()->for($user)->for($sandwich)->create(['amount' => 100000, 'balance' => 70000, 'paid_won' => 90000]);
        PointLot::factory()->for($user)->for($sandwich)->service()->create(['amount' => 20000, 'balance' => 20000]);
        // 다 쓴 가게(05-08 이전 가게)
        PointLot::factory()->for($user)->for($flower)->usedUp()->create(['amount' => 50000, 'paid_won' => 45500]);
    }
}
