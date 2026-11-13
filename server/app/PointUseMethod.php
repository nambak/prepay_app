<?php

namespace App;

/**
 * 포인트 차감을 누가 했는지. 가게용 앱의 오늘의 차감 내역에 고객차감·가게차감으로 나뉘어 보인다.
 */
enum PointUseMethod: string
{
    // 고객이 고객 앱에서 금액을 넣고 직접 쓴 경우
    case Customer = 'customer';
    // 사장님이 가게용 앱에서 손님 QR이나 전화번호로 찾아 차감 한 경우
    case Store = 'store';
}
