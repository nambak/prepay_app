// 충전할 상품 하나와 수량
import 'store.dart';

class ChargeLine {
  const ChargeLine(this.product, this.quantity);

  // 서버(ChargeController)가 받는 수량의 기술적인 상한. 충전 한도는 아직 정하지 않았다.
  static const maxQuantity = 99;

  final ChargeProduct product;
  final int quantity;

  int get amount => product.amount * quantity;
  int get priceWon => product.priceWon * quantity;
}

// 충전 상품 선택에서 고른 것. 충전 결제로 넘긴다.
class ChargeOrder {
  const ChargeOrder({required this.store, required this.lines});

  final StoreDetail store;
  final List<ChargeLine> lines; // 수량이 1 이상인 상품만.

  // 충전 포인트(P)
  int get amount => lines.fold(0, (sum, line) => sum + line.amount);

  // 결제 금액(원)
  int get priceWon => lines.fold(0, (sum, line) => sum + line.priceWon);

  // 할인 금액(원)
  int get savedWon => amount - priceWon;
}

// 충전이 끝난 뒤 서버가 돌려준 내용
class ChargeReceipt {
  const ChargeReceipt({
    required this.storeName,
    required this.amount,
    required this.paidWon,
    required this.chargedAt,
  });

  final String storeName;
  final int amount; // 충전 포인트(P)
  final int paidWon; // 결제 금액(원)
  final DateTime chargedAt;
}
