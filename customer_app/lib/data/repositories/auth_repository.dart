import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/api_client.dart';

// 로그인 상태를 가진 곳. 토큰은 기기의 안정한 저장소(iOS 키체인, Android 키스토어)에 둔다.
// 상태가 바뀌면 알려 줘서, 라우터가 로그인 다른 화면 사이를 옮겨준다.
class AuthRepository extends ChangeNotifier {
  AuthRepository({required this._apiClient}) {
    // 다른 기기에서 로그아웃했거나 토큰이 지워져서 401로 응답하면 이 기기도 로그아웃한다.
    _apiClient.onUnauthorized = _forgetToken;
  }

  static const _tokenKey = 'auth_token';

  final ApiClient _apiClient;
  final _storage = FlutterSecureStorage();

  bool get isLoggedIn => _apiClient.token != null;

  // 앱을 켤 때 한 번 호출한다. 저장해 둔 토큰이 있으면 로그인된 채로 시작한다.
  Future<void> load() async {
    _apiClient.token = await _storage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    final token = await _apiClient.login(email: email, password: password);
    await _storage.write(key: _tokenKey, value: token);
    _apiClient.token = token;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (error) {
      // 서버에 닿지 못해도 이 기기에서는 로그아웃 함.
      debugPrint('서버 로그아웃 실패: $error');
    }
    await _forgetToken();
  }

  // 탈퇴. 로그아웃과 달리 서버에서 실패하면 예외를 그대로 던지고 로그인 상태로 둔다(탈퇴가 안 됐기 때문).
  Future<void> withdraw() async {
    await _apiClient.withdraw();
    await _forgetToken();
  }

  Future<void> _forgetToken() async {
    // 메모리의 토큰부터 지워야 바로 로그인 화면으로 넘어간다. 저장소는 그 다음에 지운다.
    _apiClient.token = null;
    notifyListeners();
    await _storage.delete(key: _tokenKey);
  }
}
