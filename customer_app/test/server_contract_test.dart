import 'package:flutter_test/flutter_test.dart';
import 'package:prepay_app/data/repositories/cash_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';

// 실제 로컬 서버(php artisan serve)에 붙여 보는 테스트.
// 평소 flutter test에서는 건너뛰고, 서버를 켠 뒤 주소를 주고 실행.
const _baseUrl = String.fromEnvironment('API_BASE_URL');

void main() {
  test(
    '실제 서버의 지갑 응답을 앱 모델로 바꿀 수 있다',
    () async {
      final repository = CashRepository(
        apiClient: ApiClient(baseUrl: _baseUrl),
      );

      await expectLater(repository.getWallet(), completes);
    },
    skip: _baseUrl.isEmpty ? 'API_BASE_URL을 주면 실행함' : false,
  );
}
