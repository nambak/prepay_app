import 'package:flutter/foundation.dart';

import '../../../data/repositories/cash_repository.dart';
import '../../../domain/models/cash.dart';

class WalletViewModel extends ChangeNotifier {
  WalletViewModel({required this._cashRepository});

  final CashRepository _cashRepository;

  Wallet? _wallet;

  Wallet? get wallet => _wallet;

  String? _expandedStoreId;

  String? get expandedStoreId => _expandedStoreId;

  bool get loading => _wallet == null && !_failed;

  bool _failed = false;

  bool get failed => _failed;

  Future<void> load() async {
    _failed = false;
    notifyListeners();

    try {
      _wallet = await _cashRepository.getWallet();
      _expandedStoreId = _wallet!.stores.firstOrNull?.id;
    } catch (error) {
      debugPrint('지갑을 불러오지 못했습니다: $error');
      _failed = true;
    }
    notifyListeners();
  }

  void toggleDetail(String storeId) {
    _expandedStoreId = _expandedStoreId == storeId ? null : storeId;
    notifyListeners();
  }
}
