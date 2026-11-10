import 'dart:math';

enum StoreKind {
  cafe,
  food,
  bakery,
  beauty,
  shop;

  // 앱이 모르는 업종이 오면 일반 가게로 보여준다.
  static StoreKind fromName(Object? name) => values.asNameMap()[name] ?? shop;
}

// 가게찾기 목록의 가게 한 곳
class StoreSummary {
  const StoreSummary({
    required this.id,
    required this.name,
    required this.kind,
    required this.maxDiscountRate,
  });

  final int id;
  final String name;
  final StoreKind kind;
  final int? maxDiscountRate; // 충전 상품 중 가장 큰 할인율(%). 충전 상품이 없으면 null
}

// 충전 상품
class ChargeProduct {
  const ChargeProduct({
    required this.id,
    required this.amount,
    required this.priceWon,
    required this.discountRate,
  });

  final int id;
  final int amount; // 지갑에 충전되는 포인트(P)
  final int priceWon; // 고객이 실제로 결제하는 금액(원)
  final int discountRate; // %. 서버가 소수점을 버려서 준다.
}

// 가게 상세
class StoreDetail {
  const StoreDetail({
    required this.id,
    required this.name,
    required this.kind,
    required this.address,
    required this.phone,
    required this.chargeProducts,
  });

  final int id;
  final String name;
  final StoreKind kind;
  final String? address;
  final String? phone;
  final List<ChargeProduct> chargeProducts; // 포인트가 작은 순

  int? get maxDiscountRate => chargeProducts.isEmpty
      ? null
      : chargeProducts.map((product) => product.discountRate).reduce(max);
}
