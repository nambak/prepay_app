import '../../../data/repositories/point_repository.dart';
import '../../../domain/models/point.dart';
import '../../core/load_view_model.dart';

class WalletViewModel extends LoadViewModel<Wallet> {
  WalletViewModel({required this._pointRepository});

  final PointRepository _pointRepository;

  Wallet? get wallet => data;

  String? _expandedStoreId;

  String? get expandedStoreId => _expandedStoreId;

  @override
  Future<Wallet> fetch() async {
    final wallet = await _pointRepository.getWallet();
    // 첫 가게는 상세를 펼친 상태로 보여 준다.
    _expandedStoreId = wallet.stores.firstOrNull?.id;
    return wallet;
  }

  void toggleDetail(String storeId) {
    _expandedStoreId = _expandedStoreId == storeId ? null : storeId;
    notifyListeners();
  }
}
