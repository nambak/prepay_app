import 'package:flutter/foundation.dart';

import '../../../data/repositories/point_repository.dart';
import '../../../data/services/api_client.dart';
import '../../../domain/models/point.dart';
import '../../../domain/models/point_use.dart';
import '../../core/view_model.dart';

// 고객차감. 차감이 끝나면 receipt가 생긴다
class PointUseViewModel extends ViewModel {
  PointUseViewModel({required this._pointRepository, required this.store});

  final PointRepository _pointRepository;
  final StoreWallet store;

  int _amount = 0;

  int get amount => _amount;

  bool get overBalance => _amount > store.total;

  bool get canUse => _amount > 0 && !overBalance;

  int get balanceAfter => store.total - _amount;

  // 이번 차감을 포함한 방문 횟수. 처음 쓰는 가게는 1번째 이용이다.
  int get visitNumber => store.visitCount + 1;

  bool _submitting = false;

  bool get submitting => _submitting;

  String? _error;

  String? get error => _error;

  PointUseReceipt? _receipt;

  PointUseReceipt? get receipt => _receipt;

  // 입력칸은 숫자만 받는다. 비우면 0
  void setAmount(String text) {
    _amount = int.tryParse(text) ?? 0;
    notifyListeners();
  }

  Future<void> submit() async {
    // 버튼이 막히기 전에 두 번 눌러도 한 번만 보낸다
    if (_submitting) return;

    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      _receipt = await _pointRepository.usePoints(store.id, _amount);
    } catch (error) {
      debugPrint('쓰기 실패: $error');
      // 4xx는 서버가 요청을 받지 않은 것이라 차감되지 않는다
      // 그 밖의 응답(3xx·5xx)이나 응답이 없으면 차감됐는지 알 수 없다. 다시 누르면 두 번 차감될 수 있다
      _error = switch (error) {
        ApiException(statusCode: >= 400 && < 500) =>
          '쓰지 못했어요. 금액을 확인하고 다시 해 주세요',
        _ => '썼는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요',
      };
    }

    _submitting = false;
    notifyListeners();
  }
}
