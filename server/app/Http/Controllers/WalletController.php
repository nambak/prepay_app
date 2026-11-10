<?php

namespace App\Http\Controllers;

use App\Models\PointLot;
use App\Models\User;
use App\PointType;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;

class WalletController extends Controller
{
    /**
     * 내 가게 탭(05-01): 쓸 수 있는 포인트를 가게별로, 묶음 하나를 한 줄로 돌려준다.
     *
     * @return array{charge: int, shared: int, service: int, saved_won: int, stores: array<int, array<string, mixed>>}
     */
    public function __invoke(Request $request): array
    {
        /** @var User $user */
        $user = $request->user();

        // 아낀 금액은 다 썼거나 기한이 지난 충전까지 모두 더한다.
        $savedWonByStore = $user->pointLots()
            ->where('type', PointType::Charge)
            ->groupBy('store_id')
            ->selectRaw('store_id, sum(amount - paid_won) as saved_won')
            ->pluck('saved_won', 'store_id')
            ->map(fn ($savedWon): int => (int) $savedWon);

        $lots = $user->pointLots()
            ->usable()
            ->with('store')
            ->orderBy('expires_on')
            ->orderBy('id')
            ->get();

        $stores = $lots->groupBy('store_id')
            ->sortByDesc(fn (Collection $storeLots) => $storeLots->max('created_at'))
            ->map(function (Collection $storeLots) use ($savedWonByStore) {
                $store = $storeLots->first()->store;

                return [
                    'id' => $store->id,
                    'name' => $store->name,
                    'kind' => $store->kind,
                    'visit_count' => 0, // 쓰기 기록이 생기면 센다.
                    'saved_won' => $savedWonByStore[$store->id] ?? 0,
                    'items' => $storeLots
                        ->sortBy(fn (PointLot $lot) => array_search($lot->type, PointType::cases(), true))
                        ->map(fn (PointLot $lot) => [
                            'type' => $lot->type,
                            'amount' => $lot->balance,
                            'days_left' => $lot->daysLeft(),
                        ])
                        ->values()
                        ->all(),
                ];
            })
            ->values()
            ->all();

        $balanceOf = fn (PointType $type): int => $lots->where('type', $type)->sum('balance');

        return [
            'charge' => $balanceOf(PointType::Charge),
            'shared' => 0, // 공유 기능을 만들 때 채운다.
            'service' => $balanceOf(PointType::Service),
            'saved_won' => $savedWonByStore->sum(fn (int $savedWon): int => $savedWon),
            'stores' => $stores,
        ];
    }
}
