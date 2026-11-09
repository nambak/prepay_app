<?php

namespace App\Models;

use App\PointType;
use Database\Factories\PointLotFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Scope;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * 포인트 묶음: 충전 1건 또는 서비스포인트 지급 1건.
 * 지갑에서도 묶음 하나가 한 줄이다. 유효기간은 서비스포인트 묶음에만 있다.
 *
 * @property int $id
 * @property int $user_id
 * @property int $store_id
 * @property PointType $type
 * @property int $amount 처음 받은 포인트
 * @property int $balance 남은 포인트
 * @property int|null $paid_won 충전할 때 낸 돈(원). 서비스포인트는 null
 * @property Carbon|null $expires_on 이 날까지 쓸 수 있다
 */
#[Fillable(['store_id', 'type', 'amount', 'balance', 'paid_won'])]
class PointLot extends Model
{
    /** @use HasFactory<PointLotFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'type' => PointType::class,
            'expires_on' => 'date',
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
     * 남은 포인트가 있고, 기한이 없거나 아직 지나지 않은 묶음. 마지막 날까지 쓸 수 있다.
     *
     * @param  Builder<PointLot>  $query
     */
    #[Scope]
    protected function usable(Builder $query): void
    {
        $query->where('balance', '>', 0)
            ->where(fn (Builder $query) => $query
                ->whereNull('expires_on')
                ->orWhere('expires_on', '>=', today()->toDateString()));
    }

    /**
     * 유효기간까지 남은 날. 마지막 날이면 0. 기한이 없으면 null
     */
    public function daysLeft(): ?int
    {
        return $this->expires_on === null ? null : (int) today()->diffInDays($this->expires_on);
    }
}
