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

void main() {
  testWidgets('남은 포인트를 보여 주고, 동의해야 탈퇴할 수 있다', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'auth_token': '1|abc'});
    final apiClient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient(
            (request) async =>
        switch (request.url.path) {
          '/api/wallet' =>
              http.Response(
                jsonEncode({
                  'charge': 320000,
                  'shared': 150000,
                  'service': 30000,
                  'saved_won': 0,
                  'stores': [],
                }),
                200,
              ),
          _ => http.Response('', 204),
        },
      ),
    );
    final authRepository = AuthRepository(apiClient: apiClient);
    await authRepository.load();
    final viewModel = WithdrawViewModel(
        pointRepository: PointRepository(apiClient: apiClient),
        authRepository: authRepository
    )
      ..load();

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
}
