<?php

namespace App\Models;

use App\StoreKind;
use Database\Factories\StoreFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * 포인트를 쓰는 단위. 일반 가게 하나, 또는 프랜차이즈 브랜드 하나.
 * 프랜차이즈 지점은 지점 선택 화면(05-07)을 만들 때 따로 둔다.
 *
 * @property int $id
 * @property string $name
 * @property StoreKind $kind
 */
#[Fillable(['name', 'kind'])]
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
}
