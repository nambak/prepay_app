// 쓰기가 끝난 뒤 서버가 돌려준 내용. 사용 완료 화면에 보여준다
class PointUseReceipt {
  const PointUseReceipt({
    required this.storeName,
    required this.amount,
    required this.serviceAmount,
    required this.chargeAmount,
    required this.balance,
    required this.visitCount,
    required this.usedAt,
  });

  final String storeName;
  final int amount; // 쓴 포인트(P)
  final int serviceAmount; // 그중 서비스포인트(P)
  final int chargeAmount; // 그중 충전포인트(P)
  final int balance; // 그 가게에서 쓰고 남은 포인트(P)
  final int visitCount; // 이번 쓰기를 넣은 방문 횟수
  final DateTime usedAt;
}
