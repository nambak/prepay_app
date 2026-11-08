import 'package:flutter/cupertino.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/point_repository.dart';
import '../../../data/services/api_client.dart';

import '../../../domain/models/point.dart';
import '../../../ui/core/load_view_model.dart';

class WithdrawViewModel extends LoadViewModel<Wallet> {
  WithdrawViewModel({
    required this._pointRepository,
    required this._authRepository,
  });

  final PointRepository _pointRepository;
  final AuthRepository _authRepository;

  Wallet? get wallet => data;

  bool _agreed = false;

  bool get agreed => _agreed;

  bool _submitting = false;

  bool get submitting => _submitting;

  String? _error;

  String? get error => _error;

  // 남은 포인트를 본 뒤 동의해야 누를 수 있다.
  bool get canWithdraw => data != null && _agreed;

  @override
  Future<Wallet> fetch() => _pointRepository.getWallet();

  void agree(bool value) {
    _agreed = value;
    notifyListeners();
  }

  Future<void> withdraw() async {
    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      // 성공하면 라우터가 로그인 상태를 보고 로그인 화면으로 옮긴다.
      await _authRepository.withdraw();
    } on ApiException catch (error) {
      debugPrint('탈퇴 실파: $error');
      _error = '탈퇴하지 못했어요. 잠시 후 다시 해 주세요';
    } catch (error) {
      // 응답을 받지 못하면 서버에서 탈퇴했는지 알 수 없다.
      // 이미 탈퇴했다면 다시 누를 때 401이 와서 로그인 화면으로 간다.
      debugPrint('탈퇴됐는지 확인하지 못했어요. 잠시 후 다시 해 주세요');
    }

    _submitting = false;
    notifyListeners();
  }
}
