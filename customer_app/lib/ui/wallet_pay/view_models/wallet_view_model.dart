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

  bool get loading => _wallet == null;

  Future<void> load() async {
    _wallet = await _cashRepository.getWallet();
    _expandedStoreId =
        _wallet!.stores.firstOrNull?.id; // 디자인 시안과 같이 첫 가게는 펼쳐 둠.
    notifyListeners();
  }

  void toggleDetail(String storeId) {
    _expandedStoreId = _expandedStoreId == storeId ? null : storeId;
    notifyListeners();
  }
}
