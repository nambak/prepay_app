import '../../domain/models/cash.dart';
import '../../domain/models/store.dart';

class CashRepository {
  // 서버가 생기기 전까지 값을 체워줌
  Future<Wallet> getWallet() async => const Wallet(
    charge: 320000,
    shared: 150000,
    service: 30000,
    savedWon: 32500,
    stores: [
      StoreWallet(
        id: '1',
        name: '행복식당 1',
        kind: StoreKind.food,
        visitCount: 12,
        savedWon: 8400,
        items: [
          CashItem(CashType.charge, 150000, daysLeft: 365),
          CashItem(CashType.shared, 100000, daysLeft: 100),
          CashItem(CashType.service, 30000, daysLeft: 365),
        ],
      ),
      StoreWallet(
        id: '2',
        name: '하루카페2',
        kind: StoreKind.cafe,
        visitCount: 3,
        savedWon: 2500,
        items: [
          CashItem(CashType.charge, 100000, daysLeft: 365)
        ],
      ),
    ],
  );
}
