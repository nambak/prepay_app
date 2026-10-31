<?php

namespace App;

use Filament\Support\Contracts\HasLabel;

/**
 * 포인트 종류. 지갑에는 이 순서대로 보여 준다.
 * 공유포인트(shared)는 공유 기능을 만들 때 Charge와 Service 사이에 추가한다.
 */
enum PointType: string implements HasLabel
{
    case Charge = 'charge';
    case Service = 'service';

    public function getLabel(): string
    {
        return match ($this) {
            self::Charge => '충전포인트',
            self::Service => '서비스포인트',
        };
    }
}
