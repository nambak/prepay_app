<?php

use App\Models\User;
use Laravel\Sanctum\Sanctum;

it('지갑 포인트를 리턴한다', function () {
    Sanctum::actingAs(User::factory()->create());

    $this->getJson('/api/wallet')
        ->assertOk()
        ->assertJsonPath('charge', 320000)
        ->assertJsonCount(2, 'stores')
        ->assertJsonStructure([
            'charge', 'shared', 'service', 'saved_won',
            'stores' => [
                '*' => [
                    'id', 'name', 'kind', 'visit_count', 'saved_won',
                    'items' => ['*' => ['type', 'amount', 'days_left']],
                ],
            ],
        ]);
});
