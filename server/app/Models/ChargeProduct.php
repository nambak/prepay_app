<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

/**
 * 가게의 충전 상품: amount(P)를 price_won(원)에 충전한다. 예: 50,000P를 47,500원에.
 *
 * @property int $id
 * @property int $store_id
 * @property int $amount 충전하는 포인트
 * @property int $price_won 내는 돈(원)
 */
#[Fillable(['amount', 'price_won'])]
class ChargeProduct extends Model
{
    /**
     * 할인율(%). 소수점은 버려서 실제보다 크게 보이지 않게 한다.
     */
    public function discountRate(): int
    {
        return intdiv(($this->amount - $this->price_won) * 100, $this->amount);
    }
}
