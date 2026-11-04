import 'package:flutter/cupertino.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';

import '../../../domain/models/point.dart';

class WithdrawViewModel extends ChangeNotifier {
  WithdrawViewModel({
    required this._pointRepository,
    required this._authRepository,
  });

  final PointRepository _pointRepository;
  final AuthRepository _authRepository;

  Wallet? _wallet;

  Wallet? get wallet => _wallet;

  bool _failed = false;

  bool get failed => _failed;

  bool _agreed = false;

  bool get agreed => _agreed;

  bool _submitting = false;

  bool get submitting => _submitting;

  String? _error;

  String? get error => _error;

  // 남은 포인트를 본 뒤 동의해야 누를 수 있다.
  bool get canWithdraw => _wallet != null && _agreed;

  Future<void> load() async {
    _failed = false;
    notifyListeners();

    try {
      _wallet = await _pointRepository.getWallet();
    } catch (error) {
      debugPrint('포인트를 불러오지 못했습니다: $error');
      _failed = true;
    }
    notifyListeners();
  }

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
    } catch (error) {
      debugPrint('탈퇴 실패: $error');
      _error = '탈퇴하지 못했어요. 잠시 후 다시 해 주세요';
    }

    _submitting = false;
    notifyListeners();
  }
}
