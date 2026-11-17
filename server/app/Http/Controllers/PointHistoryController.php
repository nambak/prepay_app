<?php

namespace App\Http\Controllers;

use App\Enums\PointType;
use App\Models\PointLot;
use App\Models\PointUse;
use App\Models\User;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
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

        $lots = $this->latestIn($user->pointLots()->where('type', PointType::Charge), $request);

        return [
            'balance' => $this->balanceOf($user, PointType::Charge),
            'items' => $lots->map(fn (PointLot $lot) => [
                'id' => $lot->id,
                'store_id' => $lot->store_id,
                'store_name' => $lot->store->name,
                'amount' => $lot->amount,
                'paid_won' => $lot->paid_won,
                'charged_at' => $lot->created_at->toIso8601String(),
            ])->all(),
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

        $uses = $this->latestIn($user->pointUses()->withAmountsByType()->withVisitNumber(), $request);

        return [
            'balance' => $this->balanceOf($user, PointType::Charge),
            // 스코프가 select로 더한 값은 모델 속성이 아니어서 getAttribute로 읽는다
            'items' => $uses->map(fn (PointUse $use) => [
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
            ])->all(),
        ];
    }

    /**
     * 서비스포인트: 받은 서비스포인트 1건이 묶음 1개
     *
     * @return array{balance: int, items: array<int, array<string, mixed>>}
     */
    public function service(Request $request): array
    {
        /** @var User $user */
        $user = $request->user();

        $lots = $this->latestIn($user->pointLots()->where('type', PointType::Service), $request);

        return [
            'balance' => $this->balanceOf($user, PointType::Service),
            'items' => $lots->map(fn (PointLot $lot) => [
                'id' => $lot->id,
                'store_id' => $lot->store_id,
                'store_name' => $lot->store->name,
                'amount' => $lot->amount,   // 받은 포인트. 남은 포인트가 아니다
                'status' => $lot->status(),
                // 다 썼어도 기한이 남았으면 준다
                'days_left' => $lot->daysLeft(),
                'received_at' => $lot->created_at->toIso8601String(),
            ])->all(),
        ];
    }

    /**
     * 고른 기간의 기록을 가게와 함께 최신 순으로 불러온다
     *
     * @template TModel of Model
     *
     * @param  HasMany<TModel, User>  $query
     * @return Collection<int, TModel>
     */
    private function latestIn(HasMany $query, Request $request): Collection
    {
        return $query->whereBetween('created_at', $this->period($request))
            ->with('store')
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get();
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

    // 그 종류의 쓸 수 있는 포인트. 지갑(/api/wallet)의 charge·service와 같은 값이다
    private function balanceOf(User $user, PointType $type): int
    {
        return (int) $user->pointLots()
            ->where('type', $type)
            ->usable()
            ->sum('balance');
    }
}
