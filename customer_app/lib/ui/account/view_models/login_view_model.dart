import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/api_client.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required this._authRepository});

  final AuthRepository _authRepository;

  bool _submitting = false;

  bool get submitting => _submitting;

  String? _error;

  String? get error => _error;

  Future<void> login({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _error = '이메일과 비밀번호를 입력해 주세요.';
      notifyListeners();
      return;
    }

    _submitting = true;
    _error = null;
    notifyListeners();

    try {
      // 성공하면 라우터가 로그인 상태를 보고 지갑 화면으로 이동한다.
      await _authRepository.login(email: email.trim(), password: password);
    } on ApiException catch (error) {
      _error = switch (error.statusCode) {
        422 => '이메일 또는 비밀번호를 확인해 주세요.',
        429 => '시도가 너무 많아요. 잠시 후 다시 해 주세요',
        _ => '로그인하지 못했어요. 잠시 후 다시 해 주세요',
      };
    } catch (error) {
      debugPrint('로그인 실패: $error');
      _error = '서버에 연결하지 못했어요. 잠시 후 다시 해 주세요';
    }

    _submitting = false;
    notifyListeners();
  }
}
