<?php

namespace App\Http\Controllers;

use App\Models\Store;
use App\Models\User;
use App\PointType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PointUseController extends Controller
{
    public function __invoke(Request $request, Store $store): JsonResponse
    {
        $validated = $request->validate([
            'amount' => ['required', 'integer', 'min:1'],
        ]);

        /** @var User $user */
        $user = $request->user();
        $use = $user->usePoints($store, $validated['amount']);

        $usedOf = fn (PointType $type): int => (int) $use->lots()
            ->where('point_lots.type', $type)
            ->sum('point_use_lots.amount');

        return response()->json([
            'id' => $use->id,
            'store_name' => $store->name,
            'amount' => $use->amount,
            'service_amount' => $usedOf(PointType::Service),
            'charge_amount' => $usedOf(PointType::Charge),
            'balance' => (int) $user->pointLots()->where('store_id', $store->id)->usable()->sum('balance'),
            'visit_count' => $user->pointUses()->where('store_id', $store->id)->count(),
            'used_at' => $use->created_at->toIso8601String(),
        ], 201);
    }
}
