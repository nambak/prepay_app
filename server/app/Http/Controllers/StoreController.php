<?php

namespace App\Http\Controllers;

use App\Models\ChargeProduct;
use App\Models\Store;

class StoreController extends Controller
{
    /**
     * 가게 목록: 모든 가게를 한 번에 돌려준다. 지역·거리 정렬을 만들 때 페이지로 나눈다.
     *
     * @return array<int, array<string, mixed>>
     */
    public function index(): array
    {
        return Store::with('chargeProducts')->orderBy('id')->get()
            ->map(fn(Store $store) => [
                'id'                => $store->id,
                'name'              => $store->name,
                'kind'              => $store->kind,
                'max_discount_rate' => $store->chargeProducts->max(fn(ChargeProduct $product) => $product->discountRate()),
            ])
            ->all();
    }

    /**
     * 가게 상세: 가게 정보와 충전 상품(포인트가 작은 순).
     *
     * @return array<string, mixed>
     */
    public function show(Store $store): array
    {
        return [
            'id'              => $store->id,
            'name'            => $store->name,
            'kind'            => $store->kind,
            'address'         => $store->address,
            'phone'           => $store->phone,
            'charge_products' => $store->chargeProducts()->orderBy('amount')->get()
                ->map(fn(ChargeProduct $product) => [
                    'id'            => $product->id,
                    'amount'        => $product->amount,
                    'price_won'     => $product->price_won,
                    'discount_rate' => $product->discountRate(),
                ])
                ->all(),
        ];
    }
}
