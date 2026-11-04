import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/my/view_models/withdraw_view_model.dart';
import 'package:prepay_app/ui/my/widgets/withdraw_screen.dart';

// 서버 WalletController와 같은 모양의 응답
const _wallet = {
  'charge': 320000,
  'shared': 150000,
  'service': 30000,
  'saved_won': 0,
  'stores': <Object>[],
};

// 로그인된 상태로 시작한다. 지갑은 바로 돌려주고, 탈퇴(DELETE /api/user)는 deleteUser가 정한 대로 응답한다.
Future<(WithdrawViewModel, AuthRepository)> _setUp(
  Future<http.Response> Function() deleteUser,
) async {
  FlutterSecureStorage.setMockInitialValues({'auth_token': '1|abc'});
  final apiClient = ApiClient(
    baseUrl: 'http://test',
    client: MockClient(
        (request) async => request.url.path == '/api/wallet'
          ? http.Response(jsonEncode(_wallet), 200)
          : deleteUser(),
    )
  );
  final authRepository = AuthRepository(apiClient: apiClient);
  await authRepository.load();
  final viewModel = WithdrawViewModel(
      pointRepository: PointRepository(apiClient: apiClient),
      authRepository: authRepository
  )..load();
  return (viewModel, authRepository);
}

void main() {
  testWidgets('남은 포인트를 보여 주고, 동의해야 탈퇴할 수 있다', (tester) async {
    final (viewModel, authRepository) = await _setUp(
        () async => http.Response('', 204),
    );

    await tester.pumpWidget(
        MaterialApp(theme: appTheme, home: WithdrawScreen(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();
    expect(find.text('500,000'), findsOneWidget);

    // 동의하기 전에는 누를 수 없다.
    final withdrawButton = find.widgetWithText(FilledButton, '탈퇴하기');
    expect(tester.widget<FilledButton>(withdrawButton).onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(withdrawButton);
    await tester.pumpAndSettle();

    expect(authRepository.isLoggedIn, isFalse);
  });

  testWidgets('탈퇴 요청 중에는 취소해도 화면을 닫지 않는다', (tester) async {
    // 탈퇴 응답을 테스트가 보낼 때까지 붙잡아 둔다
    final deleting = Completer<http.Response>();
    final (viewModel, _) = await _setUp(() => deleting.future);

    // 최소하면 돌아갈 화면이 있어야 해서, 빈 화면 위에 탈퇴 화면을 올린다.
    await tester.pumpWidget(MaterialApp(theme: appTheme, home: const SizedBox()));
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => WithdrawScreen(viewModel: viewModel)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '탈퇴하기'));
    await tester.pump();

    // 탈퇴 화면이 닫히면 돌아갈 화면이 없어져 canPop이 false가 된다.
    await tester.tap(find.text('취소'));
    await tester.pump();
    expect(navigator.canPop(), isTrue);

    deleting.complete(http.Response('', 204));
    await tester.pumpAndSettle();
  });
}
