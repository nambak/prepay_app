import 'store.dart';

enum PointType { charge, shared, service }

// 포인트 종류 하나의 잔액. 단위는 P
class PointItem {
  const PointItem(this.type, this.amount, {this.daysLeft});

  final PointType type;
  final int amount;
  final int? daysLeft; // 유효기간까지 남은 날. 충전 포인트는 기한이 없어서 null
}

// 내 가게 하나
class StoreWallet {
  const StoreWallet({
    required this.id,
    required this.name,
    required this.kind,
    required this.visitCount,
    required this.savedWon,
    required this.items,
  });

  final String id;
  final String name;
  final StoreKind kind;
  final int visitCount;
  final int savedWon; // 아낀 금액. 단위는 원.
  final List<PointItem> items;

  int get total => items.fold(0, (sum, item) => sum + item.amount);
}

// 내 가게 탭 전체
class Wallet {
  const Wallet({
    required this.charge,
    required this.shared,
    required this.service,
    required this.savedWon,
    required this.stores,
  });

  final int charge;
  final int shared;
  final int service;
  final int savedWon;
  final List<StoreWallet> stores;

  int get total => charge + shared + service;
}
