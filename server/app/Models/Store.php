<?php

namespace App\Models;

use App\StoreKind;
use Database\Factories\StoreFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * 포인트를 쓰는 단위. 일반 가게 하나, 또는 프랜차이즈 브랜드 하나.
 * 프랜차이즈 지점은 지점 선택 화면(05-07)을 만들 때 따로 둔다.
 *
 * @property int $id
 * @property string $name
 * @property StoreKind $kind
 * @property string|null $address
 * @property string|null $phone
 */
#[Fillable(['name', 'kind', 'address', 'phone'])]
class Store extends Model
{
    /** @use HasFactory<StoreFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'kind' => StoreKind::class,
        ];
    }

    /**
     * @return HasMany<ChargeProduct, $this>
     */
    public function chargeProducts(): HasMany
    {
        return $this->hasMany(ChargeProduct::class);
    }
}
