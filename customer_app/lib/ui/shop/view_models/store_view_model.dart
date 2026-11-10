import '../../../data/repositories/store_repository.dart';
import '../../../domain/models/charge.dart';
import '../../../domain/models/store.dart';
import '../../core/load_view_model.dart';

// 가가 상세. 충전 상품마다 고른 수량은 가게 상세와 충전 상품 선택이 함께 쓴다.
class StoreViewModel extends LoadViewModel<StoreDetail> {
  StoreViewModel({required this._storeRepository, required this.storeId});

  final StoreRepository _storeRepository;
  final int storeId;

  StoreDetail? get store => data;

  // 충전 상품 id -> 고른 수량
  final _quantities = <int, int>{};

  @override
  Future<StoreDetail> fetch() async {
    final store = await _storeRepository.getStore(storeId);

    // 처음에는 가장 작은 상품 하나를 골라 둔다.
    _quantities
      ..clear()
      ..addAll({
        for (final (index, product) in store.chargeProducts.indexed)
          product.id: index == 0 ? 1 : 0,
      });

    return store;
  }

  int quantityOf(ChargeProduct product) => _quantities[product.id] ?? 0;

  void setQuantity(ChargeProduct product, int quantity) {
    _quantities[product.id] = quantity.clamp(0, ChargeLine.maxQuantity);
    notifyListeners();
  }

  // 불러온 뒤에만 부른다.
  ChargeOrder get order => ChargeOrder(
    store: store!,
    lines: [
      for (final product in store!.chargeProducts)
        if (quantityOf(product) > 0) ChargeLine(product, quantityOf(product)),
    ],
  );
}
