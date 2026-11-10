<?php

namespace App\Http\Controllers;

use App\Models\Store;
use App\PointType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ChargeController extends Controller
{
    /**
     * 충전: 고른 충전 상품만큼 충전포인트 묶음을 하나 만들고, 충전 완료 화면(04-08)에 보일 내용을 돌려준다.
     * 포인트와 낼 돈은 앱이 보낸 값을 믿지 않고 이 가게의 충전 상품으로 계산한다.
     */
    public function __invoke(Request $request, Store $store): JsonResponse
    {
        $products = $store->chargeProducts->keyBy('id');

        $validated = $request->validate([
            'items' => ['required', 'array'],
            'items.*.charge_product_id' => ['required', 'integer', 'distinct', Rule::in($products->keys())],
            // 잘못 눌러 큰 수가 들어오지 않게 막는 기술적인 상한. 충전 한도는 아직 정하지 않았다.
            'items.*.quantity' => ['required', 'integer', 'min:1', 'max:99'],
        ]);

        $amount = 0;
        $paidWon = 0;
        foreach ($validated['items'] as $item) {
            $product = $products[$item['charge_product_id']];
            $amount += $product->amount * $item['quantity'];
            $paidWon += $product->price_won * $item['quantity'];
        }

        // 가짜 결제: 결제된 것으로 본다. PG사가 정해지면 여기서 결제 승인을 받는다.
        $lot = $request->user()->pointLots()->create([
            'store_id' => $store->id,
            'type' => PointType::Charge,
            'amount' => $amount,
            'balance' => $amount,
            'paid_won' => $paidWon,
        ]);

        return response()->json([
            'id' => $lot->id,
            'store_name' => $store->name,
            'amount' => $lot->amount,
            'paid_won' => $lot->paid_won,
            'charged_at' => $lot->created_at->toIso8601String(),
        ], 201);
    }
}
