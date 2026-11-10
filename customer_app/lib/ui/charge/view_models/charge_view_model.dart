import 'package:flutter/material.dart';

import '../../../data/repositories/point_repository.dart';
import '../../../data/services/api_client.dart';
import '../../../domain/models/charge.dart';

// 충전 결제. 결제가 끝나면 receipt가 생기고 충전 완료를 보여준다.
class ChargeViewModel extends ChangeNotifier {
  ChargeViewModel({required this._pointRepository, required this.order});

  final PointRepository _pointRepository;
  final ChargeOrder order;

  bool _agreed = false;

  bool get agreed => _agreed;

  bool _submitting = false;

  bool get submitting => _submitting;

  String? _error;

  String? get error => _error;

  ChargeReceipt? _receipt;

  ChargeReceipt? get receipt => _receipt;

  void agree(bool value) {
    _agreed = value;
    notifyListeners();
  }

  Future<void> pay() async {
    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      _receipt = await _pointRepository.charge(order);
    } on ApiException catch (error) {
      debugPrint('충전 실패: $error');
      _error = '결제하지 못했어요. 잠시 후 다시 해 주세요';
    } catch (error) {
      // 응답을 받지 못하면 충전됐는지 알 수 없다. 다시 누르면 두 번 충전될 수 있다.
      debugPrint('충전 응답 없음: $error');
      _error = '충전됐는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요';
    }

    _submitting = false;
    notifyListeners();
  }
}
