import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/account/view_models/login_view_model.dart';
import 'package:prepay_app/ui/account/widgets/login_screen.dart';
import 'package:prepay_app/ui/core/theme.dart';

LoginViewModel _viewModel(http.Response loginResponse) => LoginViewModel(
  authRepository: AuthRepository(
    apiClient: ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => loginResponse),
    ),
  ),
);

void main() {
  String email = 'hana@email.com';
  String password = 'password1234';

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('비어 있으면 서버에 보내지 않고 안내한다', () async {
    final viewModel = _viewModel(http.Response('', 500));

    await viewModel.login(email: '', password: '');
    expect(viewModel.error, '이메일과 비밀번호를 입력해 주세요.');
  });

  test('비밀번호가 틀리면(422) 확인해 달라고 안내한다', () async {
    final viewModel = _viewModel(http.Response('', 422));

    await viewModel.login(email: email, password: 'wrong');
    expect(viewModel.error, '이메일 또는 비밀번호를 확인해 주세요.');
  });

  test('맞으면 안내 문구 없이 끝난다', () async {
    final viewModel = _viewModel(
      http.Response(jsonEncode({'token': '1|abc'}), 200),
    );

    await viewModel.login(email: email, password: password);
    expect(viewModel.error, isNull);
  });

  testWidgets('390x844 화면에 넘치지 않고, 틀리면 비밀번호 아래에 안내가 나온다', (tester) async {
    tester.view.physicalSize = Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: LoginScreen(viewModel: _viewModel(http.Response('{}', 422))),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), email);
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(find.text('이메일 또는 비밀번호를 확인해 주세요.'), findsOneWidget);
  });
}
