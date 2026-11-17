<?php

namespace App\Enums;

/**
 * 포인트 묶음을 지금 쓸 수 있는지. 포인트 내역의 서비스포인트 배지에 쓴다
 */
enum PointLotStatus: string
{
    // 남은 포인트가 있고 기한이 지나지 않았다
    case Usable = 'usable';
    // 남은 포인트가 0. 기한은 보지 않음
    case UsedUp = 'used_up';
    // 남은 포인트가 있는데 기한이 지남
    case Expired = 'expired';
}
