<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\PointType;
use App\PointUseMethod;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Laravel\Sanctum\HasApiTokens;

/**
 * @property int $id
 * @property string|null $name
 * @property string|null $email
 * @property Carbon|null $email_verified_at
 * @property string|null $password
 * @property string|null $remember_token
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property Carbon|null $withdrawn_at
 */
#[Fillable(['name', 'email', 'password'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'withdrawn_at' => 'datetime',
        ];
    }

    /**
     * @return HasMany<PointLot, $this>
     */
    public function pointLots(): HasMany
    {
        return $this->hasMany(PointLot::class);
    }

    /**
     * @return HasMany<PointUse, $this>
     */
    public function pointUses(): HasMany
    {
        return $this->hasMany(PointUse::class);
    }

    public function usePoints(Store $store, int $amount, PointUseMethod $method = PointUseMethod::Customer): PointUse
    {
        return DB::transaction(function () use ($store, $amount, $method) {
            $lots = $this->pointLots()
                ->where('store_id', $store->id)
                ->usable()
                ->orderByRaw('case when type = ? then 0 else 1 end', [PointType::Service->value])
                ->orderBy('expires_on')
                ->orderBy('id')
                ->get();

            $tooMuch = ValidationException::withMessages(['amount' => '쓸 수 있는 포인트 보다 많아요.']);

            if ($amount > $lots->sum('balance')) {
                throw $tooMuch;
            }

            $use = $this->pointUses()->create([
                'store_id' => $store->id,
                'method' => $method,
                'amount' => $amount,
            ]);

            $left = $amount;
            foreach ($lots as $lot) {
                $take = min($lot->balance, $left);

                // 읽은 뒤에 다른 요청이 먼저 뺐으면 줄이지 않는다.
                $taken = PointLot::whereKey($lot->id)
                    ->where('balance', '>=', $take)
                    ->decrement('balance', $take);

                if ($taken === 0) {
                    throw $tooMuch;
                }

                $use->lots()->attach($lot->id, ['amount' => $take]);
                $left -= $take;

                if ($left === 0) {
                    break;
                }
            }

            return $use;
        });
    }

    /**
     * 탈퇴: 회원 행은 남기고 개인정보만 비운다. 포인트 묶음(결제 기록)은 그대로 둔다.
     * 앱의 탈퇴(DELETE /api/user)와 관리자 웹의 '탈퇴 처리'가 함께 쓴다.
     */
    public function withdraw(): void
    {
        DB::transaction(function () {
            $this->tokens()->delete();
            $this->forceFill([
                'name' => null,
                'email' => null,
                'email_verified_at' => null,
                'password' => null,
                'remember_token' => null,
                'withdrawn_at' => now(),
            ])->save();
        });
    }

    /**
     * Get the user's initials
     */
    public function initials(): string
    {
        $initials = Str::initials($this->name, true);

        return Str::length($initials) > 1
            ? Str::substr($initials, 0, 1).Str::substr($initials, -1)
            : $initials;
    }
}
