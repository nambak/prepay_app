<?php

namespace Database\Factories;

use App\Enums\StoreKind;
use App\Models\Store;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Store>
 */
class StoreFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->company(),
            'kind' => fake()->randomElement(StoreKind::cases()),
        ];
    }
}
