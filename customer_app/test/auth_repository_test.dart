import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';

ApiClient _apiClient(int walletStatus) => ApiClient(
  baseUrl: 'http://test',
  client: MockClient(
    (request) async => switch (request.url.path) {
      '/api/login' => http.Response(jsonEncode({'token': '1|abc'}), 200),
      '/api/logout' => http.Response('', 204),
      _ => http.Response('{}', walletStatus),
    },
  ),
);

void main() {
  // 테스트는 키체인이 없으므로 저장소를 메모리로 바꿔서 테스트한다.
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  String email = 'hana@email.com';
  String password = 'password1234';

  test('로그인하면 토큰을 저장하고, 앱을 다시 켜도 로그인이 유지된다', () async {
    final first = AuthRepository(apiClient: _apiClient(200));
    await first.login(email: email, password: password);
    expect(first.isLoggedIn, isTrue);

    // 앱을 다시 켠 것처럼 새로 만들어서 불러온다.
    final restarted = AuthRepository(apiClient: _apiClient(200));
    expect(restarted.isLoggedIn, isFalse);
    await restarted.load();
    expect(restarted.isLoggedIn, isTrue);
  });

  test('로그아웃하면 토큰이 지워진다', () async {
    final repository = AuthRepository(apiClient: _apiClient(200));
    await repository.login(email: email, password: password);

    await repository.logout();
    expect(repository.isLoggedIn, isFalse);

    await repository.load();
    expect(repository.isLoggedIn, isFalse);
  });

  test('토큰이 서버에서 지워져 401이 오면 이 기기도 로그아웃된다', () async {
    final apiClient = _apiClient(401);
    final repository = AuthRepository(apiClient: apiClient);
    await repository.login(email: email, password: password);

    await expectLater(apiClient.getWallet(), throwsA(isA<ApiException>()));
    expect(repository.isLoggedIn, isFalse);
  });

  test('탈퇴하면 토큰이 지워진다', () async {
    final repository = AuthRepository(apiClient: _apiClient(200));
    await repository.login(email: email, password: password);

    await repository.withdraw();
    expect(repository.isLoggedIn, isFalse);
  });

  test('서버에서 탈퇴하지 못하면 로그인 상태를 유지한다', () async {
    final repository = AuthRepository(apiClient: _apiClient(500));
    await repository.login(email: email, password: password);

    await expectLater(repository.withdraw(), throwsA(isA<ApiException>()));
    expect(repository.isLoggedIn, isTrue);
  });
}
