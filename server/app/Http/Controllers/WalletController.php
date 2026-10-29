<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class WalletController extends Controller
{
    /**
     * DB 생성 전까지 시안(05-01)의 값을 리턴한다. 앱 CashRepository의 더미와 같은 값이다.
     */
    public function __invoke(Request $request)
    {
        return [
            'charge'    => 320000,
            'shared'    => 150000,
            'service'   => 30000,
            'saved_won' => 32500,
            'stores'    => [
                [
                    'id'          => 1,
                    'name'        => '행복식당 1',
                    'kind'        => 'food',
                    'visit_count' => 12,
                    'saved_won'   => 8400,
                    'items'       => [
                        ['type' => 'charge', 'amount' => 100000, 'days_left' => 365],
                        ['type' => 'shared', 'amount' => 100000, 'days_left' => 100],
                        ['type' => 'service', 'amount' => 30000, 'days_left' => 365],
                    ],
                ],
                [
                    'id'          => 2,
                    'name'        => '하루카페2',
                    'kind'        => 'cafe',
                    'visit_count' => 3,
                    'saved_won'   => 2500,
                    'items'       => [
                        ['type' => 'charge', 'amount' => 100000, 'days_left' => 365],
                    ],
                ],
            ],
        ];
    }
}
