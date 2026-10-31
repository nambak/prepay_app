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
        $restaurant = Store::factory()->create(['name' => '행복식당 1', 'kind' => StoreKind::Food]);
        $cafe = Store::factory()->create(['name' => '하루카페2', 'kind' => StoreKind::Cafe]);
        $sandwich = Store::factory()->create(['name' => '행복샌드위치', 'kind' => StoreKind::Food]);
        $flower = Store::factory()->create(['name' => '봄꽃집', 'kind' => StoreKind::Shop]);

        PointLot::factory()->for($user)->for($restaurant)->create(['amount' => 150000, 'balance' => 150000, 'paid_won' => 127500]);
        PointLot::factory()->for($user)->for($restaurant)->service()->create(['amount' => 30000, 'balance' => 30000, 'expires_on' => today()->addYear()]);
        PointLot::factory()->for($user)->for($cafe)->create(['amount' => 100000, 'balance' => 100000, 'paid_won' => 80000]);
        PointLot::factory()->for($user)->for($sandwich)->create(['amount' => 100000, 'balance' => 70000, 'paid_won' => 90000]);
        PointLot::factory()->for($user)->for($sandwich)->service()->create(['amount' => 20000, 'balance' => 20000]);
        // 다 쓴 가게(05-08 이전 가게)
        PointLot::factory()->for($user)->for($flower)->usedUp()->create(['amount' => 50000, 'paid_won' => 45500]);
    }
}
