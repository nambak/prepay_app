<?php

namespace App\Http\Controllers;

use App\Models\PointLot;
use App\Models\PointUse;
use App\Models\User;
use App\PointType;
use Illuminate\Database\Eloquent\Builder;
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
     * 가게 이용 내역: 차감 1건이 한 줄이다
     *
     * @return array{balance: int, items: array<int, array<string, mixed>>}
     */
    public function uses(Request $request): array
    {
        /** @var User $user */
        $user = $request->user();

        // 차감 1건에서 그 종류의 묶음으로 뺀 포인트 합
        $usedOf = fn (PointType $type) => fn (Builder $query) => $query->where('point_lots.type', $type);

        $items = $user->pointUses()
            ->whereBetween('created_at', $this->period($request))
            ->with('store')
            ->withSum(['lots as charge_amount' => $usedOf(PointType::Charge)], 'point_use_lots.amount')
            ->withSum(['lots as service_amount' => $usedOf(PointType::Service)], 'point_use_lots.amount')
            // 그 가게에서 몇 번째로 차감한 것인지. 기간과 상관없이 이 기록까지 센다
            ->addSelect(['visit_number' => PointUse::from('point_uses as earlier')
                ->selectRaw('count(*)')
                ->whereColumn('earlier.user_id', 'point_uses.user_id')
                ->whereColumn('earlier.store_id', 'point_uses.store_id')
                ->whereColumn('earlier.id', '<=', 'point_uses.id'),
            ])
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get()
            // 위에서 select로 더한 값이라 모델 속성이 아니어서 getAttribute로 읽는다
            ->map(fn (PointUse $use) => [
                'id' => $use->id,
                'store_id' => $use->store_id,
                'store_name' => $use->store->name,
                'visit_number' => (int) $use->getAttribute('visit_number'),
                'method' => $use->method,
                'amount' => $use->amount,
                'charge_amount' => (int) $use->getAttribute('charge_amount'),
                'shared_amount' => 0,   // 공유 기능을 만들 때 채운다
                'service_amount' => (int) $use->getAttribute('service_amount'),
                'used_at' => $use->created_at->toIso8601String(),
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
