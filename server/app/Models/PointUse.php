<?php

namespace App\Models;

use App\PointUseMethod;
use Illuminate\Database\Eloquent\Attributes\Fillable;
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
}
