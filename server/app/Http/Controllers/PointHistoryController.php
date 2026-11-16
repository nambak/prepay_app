<?php

namespace App\Http\Controllers;

use App\Models\PointLot;
use App\Models\User;
use App\PointType;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

/**
 * 포인트 내역: 기간(year, month)내의 기록을 최신 순으로 돌려준다
 * 가게 찾기와 정렬은 앱이 받아 온 목록 안에서 한다
 */
class PointHistoryController extends Controller
{
    /**
     * 결제 내역: 충전 1건이 묶음 1개
     *
     * @return array{balance: int, items: array<int, array<string, mixed>>}
     */
    public function charges(Request $request): array
    {
        /** @var User $user */
        $user = $request->user();

        $items = $user->pointLots()
            ->where('type', PointType::Charge)
            ->whereBetween('created_at', $this->period($request))
            ->with('store')
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get()
            ->map(fn (PointLot $lot) => [
                'id' => $lot->id,
                'store_id' => $lot->store_id,
                'store_name' => $lot->store->name,
                'amount' => $lot->amount,
                'paid_won' => $lot->paid_won,
                'charged_at' => $lot->created_at->toIso8601String(),
            ])
            ->all();

        return [
            'balance' => $this->chargeBalance($user),
            'items' => $items,
        ];
    }

    /**
     * 기간의 처음과 끝. month가 없으면 그 해 전체. 시각은 서버 시간대(Asia/Seoul) 기준이다
     *
     * @return array{0: Carbon, 1:Carbon}
     */
    private function period(Request $request): array
    {
        $validated = $request->validate([
            'year' => ['required', 'integer', 'digits:4'],
            'month' => ['nullable', 'integer', 'between:1,12'],
        ]);

        $month = isset($validated['month']) ? (int) $validated['month'] : null;
        $from = Carbon::create((int) $validated['year'], $month ?? 1);

        return [$from, $month === null ? $from->copy()->endOfYear() : $from->copy()->endOfMonth()];
    }

    // 쓸 수 있는 충전포인트. 지갑(/api/wallet)의 charge와 같은 값이다
    private function chargeBalance(User $user): int
    {
        return (int) $user->pointLots()
            ->where('type', PointType::Charge)
            ->usable()
            ->sum('balance');
    }
}
