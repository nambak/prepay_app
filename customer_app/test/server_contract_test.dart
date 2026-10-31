import 'package:flutter_test/flutter_test.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';

// 실제 로컬 서버에 붙여 보는 테스트.
// 평소 flutter test에서는 건너뛰고, 서버 주소와 테스트 계정을 주고 실행.
const _baseUrl = String.fromEnvironment('API_BASE_URL');
const _email = String.fromEnvironment('TEST_EMAIL');
const _password = String.fromEnvironment('TEST_PASSWORD');

void main() {
  test(
    '실제 서버에 로그인해서 지갑 응답을 앱 모델로 바꿀 수 있다',
    () async {
      final apiClient = ApiClient(baseUrl: _baseUrl);
      apiClient.token = await apiClient.login(
        email: _email,
        password: _password,
      );
      addTearDown(apiClient.logout);  // 테스트로 만든 토큰은 지운다.

      final repository = PointRepository(apiClient: apiClient);
      await expectLater(repository.getWallet(), completes);
    },
    skip: _baseUrl.isEmpty || _email.isEmpty
        ? 'API_BASE_URL, TEST_EMAIL, TEST_PASSWORD 를 주면 실행함'
        : false,
  );
}
