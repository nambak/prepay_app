<?php

namespace App\Models;

use App\Enums\PointType;
use App\Enums\PointUseMethod;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Scope;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Carbon;

/**
 * 포인트 차감 1건. 어느 묶음에서 얼마를 뺐는지는 point_use_lots에 넣는다.
 *
 * @property int $id
 * @property int $user_id
 * @property int $store_id
 * @property PointUseMethod $method
 * @property int $amount 차감한 포인트
 * @property Carbon $created_at 차감한 시각
 */
#[Fillable(['store_id', 'method', 'amount'])]
class PointUse extends Model
{
    protected function casts(): array
    {
        return [
            'method' => PointUseMethod::class,
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return BelongsTo<Store, $this>
     */
    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }

    /**
     * 해당 차감으로 줄어든 묶음. pivot의 amount가 그 묶음에서 뺀 포인트다.
     *
     * @return BelongsToMany<PointLot, $this>
     */
    public function lots(): BelongsToMany
    {
        return $this->belongsToMany(PointLot::class, 'point_use_lots')->withPivot('amount');
    }

    /**
     * 쓰기 1건에서 충전포인트·서비스포인트 묶음으로 뺀 포인트를 charge_amount, service_amount로 더한다
     *
     * @param  Builder<PointUse>  $query
     */
    #[Scope]
    protected function withAmountsByType(Builder $query): void
    {
        $from = fn (PointType $type) => fn (Builder $lots) => $lots->where('point_lots.type', $type);

        $query->withSum(['lots as charge_amount' => $from(PointType::Charge)], 'point_use_lots.amount')
            ->withSum(['lots as service_amount' => $from(PointType::Service)], 'point_use_lots.amount');
    }

    /**
     * 그 가게에서 몇 번째로 쓴 것인지 visit_number로 더한다. 기간과 상관없이 이 기록까지 센다
     *
     * @param  Builder<PointUse>  $query
     */
    #[Scope]
    protected function withVisitNumber(Builder $query): void
    {
        $query->addSelect(['visit_number' => self::from('point_uses as earlier')
            ->selectRaw('count(*)')
            ->whereColumn('earlier.user_id', 'point_uses.user_id')
            ->whereColumn('earlier.store_id', 'point_uses.store_id')
            ->whereColumn('earlier.id', '<=', 'point_uses.id'),
        ]);
    }
}
