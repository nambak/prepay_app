<?php

namespace App;

use Filament\Support\Contracts\HasLabel;

/**
 * 가게 업종. 앱의 StoreKind(아이콘 묶음)와 같은 값이다.
 */
enum StoreKind: string implements HasLabel
{
    case Cafe = 'cafe';
    case Food = 'food';
    case Bakery = 'bakery';
    case Beauty = 'beauty';
    case Shop = 'shop';

    public function getLabel(): string
    {
        return match ($this) {
            self::Cafe => '카페',
            self::Food => '음식점',
            self::Bakery => '베이커리',
            self::Beauty => '뷰티',
            self::Shop => '일반 가게',
        };
    }
}
