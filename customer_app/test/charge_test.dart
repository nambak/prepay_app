import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/repositories/store_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/domain/models/charge.dart';
import 'package:prepay_app/ui/charge/view_models/charge_view_model.dart';
import 'package:prepay_app/ui/charge/widgets/charge_screen.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/shop/view_models/store_view_model.dart';
import 'package:prepay_app/ui/shop/widgets/store_screen.dart';

// 서버 StoreController·ChargeController와 같은 모양의 응답
const _storeJson = {
  'id': 2,
  'name': '하루카페2',
  'kind': 'cafe',
  'address': null,
  'phone': null,
  'charge_products': [
    {'id': 3, 'amount': 50000, 'price_won': 47500, 'discount_rate': 5},
    {'id': 4, 'amount': 100000, 'price_won': 80000, 'discount_rate': 20},
  ],
};

const _receiptJson = {
  'id': 9,
  'store_name': '하루카페2',
  'amount': 150000,
  'paid_won': 127500,
  'charged_at': '2026-11-09T14:03:00+09:00',
};

ApiClient _apiClient(Future<http.Response> Function(http.Request) handler) =>
    ApiClient(baseUrl: 'http://test', client: MockClient(handler));

// 한글이 들어 있어서 utf8 바이트로 응답을 만든다.
http.Response _json(Object json, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(json)), status);

// 시안과 같은 390x844 화면
void _usePhoneSize(WidgetTester tester) {
  tester.view.physicalSize = Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

FilledButton _button(WidgetTester tester, String label) =>
    tester.widget<FilledButton>(
      find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
    );

void main() {
  testWidgets('가게 상세에서 고른 상품으로 결제하면 충전 완료를 보여 준다', (tester) async {
    _usePhoneSize(tester);
    Object? sentBody;
    final apiClient = _apiClient((request) async {
      if (request.method == 'POST') {
        sentBody = jsonDecode(request.body);
        return _json(_receiptJson, 201);
      }
      return _json(_storeJson);
    });
    final storeViewModel = StoreViewModel(
      storeRepository: StoreRepository(apiClient: apiClient),
      storeId: 2,
    )..load();
    final router = GoRouter(
      initialLocation: '/shop/2',
      routes: [
        GoRoute(
          path: '/shop/:id',
          builder: (context, state) => StoreScreen(viewModel: storeViewModel),
          routes: [
            GoRoute(
              path: 'charge',
              builder: (context, state) => ChargeScreen(
                viewModel: ChargeViewModel(
                  pointRepository: PointRepository(apiClient: apiClient),
                  order: state.extra! as ChargeOrder,
                ),
              ),
            ),
          ],
        ),
        GoRoute(path: '/wallet', builder: (_, _) => Text('내 가게')),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.pumpAndSettle();

    // 가게 상세: 처음에는 가장 작은 상품 하나를 골라 둔다.
    expect(find.text('50,000P 충전하기'), findsOneWidget);
    await tester.scrollUntilVisible(find.byTooltip('100,000P 수량 늘리기'), 100);
    await tester.tap(find.byTooltip('100,000P 수량 늘리기'));
    await tester.pump();
    expect(find.text('150,000P 충전하기'), findsOneWidget);

    // 충전 상품 선택
    await tester.tap(find.text('150,000P 충전하기'));
    await tester.pumpAndSettle();
    expect(find.text('충전 상품 선택'), findsOneWidget);
    expect(find.text('150,000P'), findsOneWidget);
    expect(find.text('22,500원 아껴요'), findsOneWidget);

    // 충전 결제: 이용 안내를 확인해야 결제할 수 있다.
    await tester.tap(find.text('127,500원 결제하기'));
    await tester.pumpAndSettle();
    expect(find.text('포인트 충전'), findsOneWidget);
    expect(find.text('50,000P × 1'), findsOneWidget);
    expect(find.text('100,000P × 1'), findsOneWidget);
    expect(find.text('−22,500원'), findsOneWidget);
    expect(_button(tester, '127,500원 결제하기').onPressed, isNull);

    await tester.scrollUntilVisible(find.text('이용 안내를 확인했어요 (필수)'), 100);
    // 이미 그려져 있으면 끌지 않고 바로 옮기기만 해서, 한 번 다시 그려야 옮긴 자리를 누른다.
    await tester.pump();
    await tester.tap(find.text('이용 안내를 확인했어요 (필수)'));
    await tester.pump();
    await tester.tap(find.text('127,500원 결제하기'));
    await tester.pumpAndSettle();
    expect(sentBody, {
      'items': [
        {'charge_product_id': 3, 'quantity': 1},
        {'charge_product_id': 4, 'quantity': 1},
      ],
    });

    // 충전 완료
    expect(find.text('150,000P\n충전이 끝났어요'), findsOneWidget);
    expect(find.text('127,500원'), findsOneWidget);

    await tester.tap(find.text('즐겨찾는 가게에서 보기'));
    await tester.pumpAndSettle();
    expect(find.text('내 가게'), findsOneWidget);
  });

  testWidgets('상품을 하나도 고르지 않으면 충전하기를 누를 수 없다', (tester) async {
    _usePhoneSize(tester);
    final viewModel = StoreViewModel(
      storeRepository: StoreRepository(
        apiClient: _apiClient((_) async => _json(_storeJson)),
      ),
      storeId: 2,
    )..load();

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: StoreScreen(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byTooltip('50,000P 수량 줄이기'), 100);
    await tester.tap(find.byTooltip('50,000P 수량 줄이기'));
    await tester.pump();

    expect(_button(tester, '충전 상품을 골라 주세요').onPressed, isNull);
  });

  for (final (name, handler, message) in [
    ('서버가 결제를 받지 않으면', (_) async => _json({}, 422), '결제하지 못했어요. 잠시 후 다시 해 주세요'),
    (
      '서버가 다른 곳으로 보내서 충전됐는지 알 수 없으면',
      (_) async => _json({}, 302),
      '충전됐는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요',
    ),
    (
      '서버 오류로 충전됐는지 알 수 없으면',
      (_) async => _json({}, 500),
      '충전됐는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요',
    ),
    (
      '응답을 받지 못하면',
      (_) async => throw http.ClientException('연결 끊김'),
      '충전됐는지 확인하지 못했어요. 내 가게에서 포인트를 먼저 확인해 주세요',
    ),
  ]) {
    testWidgets('$name 안내하고 결제 화면에 남는다', (tester) async {
      _usePhoneSize(tester);
      final storeViewModel = StoreViewModel(
        storeRepository: StoreRepository(
          apiClient: _apiClient((_) async => _json(_storeJson)),
        ),
        storeId: 2,
      );
      await storeViewModel.load();
      final viewModel = ChargeViewModel(
        pointRepository: PointRepository(apiClient: _apiClient(handler)),
        order: storeViewModel.order,
      )..agree(true);

      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: ChargeScreen(viewModel: viewModel),
        ),
      );
      await tester.tap(find.text('47,500원 결제하기'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(_button(tester, '47,500원 결제하기').onPressed, isNotNull);
    });
  }
}
