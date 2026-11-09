<?php

namespace Database\Factories;

use App\Models\PointLot;
use App\Models\Store;
use App\Models\User;
use App\PointType;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * 기본은 100,000P를 80,000원에 충전한 묶음.
 *
 * @extends Factory<PointLot>
 */
class PointLotFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'store_id' => Store::factory(),
            'type' => PointType::Charge,
            'amount' => 100000,
            'balance' => 100000,
            'paid_won' => 80000,
            'expires_on' => null,   // 충전 포인트는 기한이 없다.
        ];
    }

    /**
     * 가게가 감사의 뜻으로 준 서비스포인트.
     */
    public function service(): static
    {
        return $this->state(fn (array $attributes) => [
            'type' => PointType::Service,
            'amount' => 10000,
            'balance' => 10000,
            'paid_won' => null,
            'expires_on' => today()->addDays(100),
        ]);
    }

    public function usedUp(): static
    {
        return $this->state(fn (array $attributes) => [
            'balance' => 0,
        ]);
    }

    /**
     * 기한이 지난 묶음. 기한은 서비스 포인트에만 있다.
     */
    public function expired(): static
    {
        return $this->state(fn (array $attributes) => [
            'expires_on' => today()->subDay(),
        ]);
    }
}
