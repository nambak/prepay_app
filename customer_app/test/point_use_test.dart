import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/widgets/view_model_scope.dart';
import 'package:prepay_app/ui/wallet_pay/view_models/point_use_view_model.dart';
import 'package:prepay_app/ui/wallet_pay/view_models/wallet_view_model.dart';
import 'package:prepay_app/ui/wallet_pay/widgets/point_use_sheet.dart';
import 'package:prepay_app/ui/wallet_pay/widgets/wallet_screen.dart';

// 서버 WalletController와 같은 모양의 응답. 행복식당 1에서 쓸 수 있는 포인트는 280,000P
const _walletJson = {
  'charge': 270000,
  'shared': 0,
  'service': 10000,
  'saved_won': 0,
  'stores': [
    {
      'id': 2,
      'name': '행복식당 1',
      'kind': 'food',
      'visit_count': 12,
      'saved_won': 0,
      'items': [
        {'type': 'charge', 'amount': 270000, 'days_left': null},
        {'type': 'service', 'amount': 10000, 'days_left': 30},
      ],
    },
  ],
};

// 서버 PointUseController와 같은 모양의 응답
const _receiptJson = {
  'id': 1,
  'store_name': '행복식당 1',
  'amount': 18800,
  'service_amount': 10000,
  'charge_amount': 8800,
  'balance': 261200,
  'visit_count': 13,
  'used_at': '2026-10-27T12:00:00+09:00',
};

ApiClient _apiClient(Future<http.Response> Function(http.Request) handler) =>
    ApiClient(baseUrl: 'http://test', client: MockClient(handler));

// 한글이 들어 있어서 utf8 바이트로 응답을 만든다
http.Response _json(Object json, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(json)), status);

// 시안과 같은 390x844 화면에 내 가게를 띄운다. 서버 응답은 handler가 정한다
Future<void> _pumpWallet(
  WidgetTester tester,
  Future<http.Response> Function(http.Request) handler,
) async {
  tester.view.physicalSize = Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final pointRepository = PointRepository(apiClient: _apiClient(handler));
  final router = GoRouter(
    initialLocation: '/wallet',
    routes: [
      GoRoute(
        path: '/wallet',
        builder: (context, state) => ViewModelScope(
          create: () =>
              WalletViewModel(pointRepository: pointRepository)..load(),
          builder: (viewModel) => WalletScreen(
            viewModel: viewModel,
            createPointUse: (store) => PointUseViewModel(
              pointRepository: pointRepository,
              store: store,
            ),
          ),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(theme: appTheme, routerConfig: router),
  );
  await tester.pumpAndSettle();
}

// 카드의 차감 → 금액 입력 → 시트의 차감을 눌러 확인 다이얼로그를 띄운다
Future<void> _openConfirm(WidgetTester tester, String amount) async {
  await tester.tap(find.text('쓰기'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), amount);
  await tester.pump();
  await tester.tap(find.textContaining('P 쓰기'));
  await tester.pumpAndSettle();
}

Finder _inSheet(String text) =>
    find.descendant(of: find.byType(PointUseSheet), matching: find.text(text));

Finder _inDialog(String text) =>
    find.descendant(of: find.byType(Dialog), matching: find.text(text));

FilledButton _button(WidgetTester tester, String label) =>
    tester.widget<FilledButton>(
      find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
    );

void main() {
  test('차감 응답을 앱 모델로 바꾼다', () async {
    http.Request? sent;
    final repository = PointRepository(
      apiClient: _apiClient((request) async {
        sent = request;
        return _json(_receiptJson, 201);
      }),
    );

    final receipt = await repository.usePoints(2, 18800);

    expect(sent!.method, 'POST');
    expect(sent!.url.path, '/api/stores/2/uses');
    expect(jsonDecode(sent!.body), {'amount': 18800});

    expect(receipt.storeName, '행복식당 1');
    expect(receipt.amount, 18800);
    expect(receipt.serviceAmount, 10000);
    expect(receipt.chargeAmount, 8800);
    expect(receipt.balance, 261200);
    expect(receipt.visitCount, 13);
    expect(receipt.usedAt, DateTime.parse('2026-10-27T12:00:00+09:00'));
  });

  testWidgets('차감에서 금액을 넣고 확인하면 서버에 보내고 지갑을 다시 불러온다', (tester) async {
    final sentBodies = [];
    var walletLoads = 0;
    await _pumpWallet(tester, (request) async {
      if (request.method == 'POST') {
        sentBodies.add(jsonDecode(request.body));
        return _json(_receiptJson, 201);
      }
      walletLoads++;
      return _json(_walletJson);
    });

    // 금액 입력
    await tester.tap(find.text('쓰기'));
    await tester.pumpAndSettle();
    expect(_inSheet('13번째 이용'), findsOneWidget);
    expect(_inSheet('280,000P'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '18800');
    await tester.pump();
    await tester.tap(find.text('18,800P 쓰기'));
    await tester.pumpAndSettle();

    // 확인
    expect(_inDialog('행복식당 1에서\n18,800P를 쓸까요?'), findsOneWidget);
    expect(_inDialog('18,800P'), findsOneWidget);
    expect(_inDialog('261,200P'), findsOneWidget);

    await tester.tap(_inDialog('쓰기'));
    await tester.pumpAndSettle();

    expect(sentBodies, [
      {'amount': 18800},
    ]);
    expect(find.byType(Dialog), findsNothing);
    expect(find.byType(PointUseSheet), findsNothing);
    expect(walletLoads, 2);
  });

  testWidgets('금액이 0이거나 쓸 수 있는 포인트보다 많으면 차감을 할 수 없다', (tester) async {
    await _pumpWallet(tester, (_) async => _json(_walletJson));
    await tester.tap(find.text('쓰기'));
    await tester.pumpAndSettle();

    expect(_button(tester, '쓸 금액을 넣어 주세요').onPressed, isNull);

    await tester.enterText(find.byType(TextField), '280001');
    await tester.pump();
    expect(_button(tester, '쓸 수 있는 포인트보다 많아요').onPressed, isNull);

    await tester.enterText(find.byType(TextField), '280000');
    await tester.pump();
    expect(_button(tester, '280,000P 쓰기').onPressed, isNotNull);

    // 숫자만. 9자리까지 들어간다
    await tester.enterText(find.byType(TextField), '12a3');
    await tester.pump();
    expect(find.text('123'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '1234567890');
    await tester.pump();
    expect(find.text('123456789'), findsOneWidget);
  });

  testWidgets('보내는 동안 쓰기를 다시 눌러도 한 번만 보내고, 취소해도 닫히지 않는다', (tester) async {
    final response = Completer<http.Response>();
    var posts = 0;
    await _pumpWallet(tester, (request) async {
      if (request.method == 'POST') {
        posts++;
        return response.future;
      }
      return _json(_walletJson);
    });
    await _openConfirm(tester, '18800');

    // 화면이 다시 그려지기 전에 두 번 누른다
    await tester.tap(_inDialog('쓰기'));
    await tester.tap(_inDialog('쓰기'));
    await tester.pump();
    expect(posts, 1);

    // 닫히는 애니메이션이 끝날 만큼만 기다린다
    // pumpAndSettle은 도는 표시 때문에 요청 시간 제한(10초)까지 흘려보낸다
    await tester.tap(_inDialog('취소'));
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(Dialog), findsOneWidget);

    response.complete(_json(_receiptJson, 201));
    await tester.pumpAndSettle();
    expect(posts, 1);
    expect(find.byType(Dialog), findsNothing);
  });

  for (final (status, message) in [
    (422, '쓰지 못했어요. 금액을 확인하고 다시 해 주세요'),
    (500, '썼는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요'),
  ]) {
    testWidgets('쓰기 응답이 $status이면 다이얼로그에 안내를 남긴다', (tester) async {
      await _pumpWallet(
        tester,
        (request) async => request.method == 'POST'
            ? _json({'message': '실패'}, status)
            : _json(_walletJson),
      );
      await _openConfirm(tester, '18800');

      await tester.tap(_inDialog('쓰기'));
      await tester.pumpAndSettle();

      expect(_inDialog(message), findsOneWidget);
      expect(_inDialog('행복식당 1에서\n18,800P를 쓸까요?'), findsOneWidget);
    });
  }
}
