<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
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
