import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/domain/models/point_history.dart';
import 'package:prepay_app/routing/routes.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/widgets/load_error.dart';
import 'package:prepay_app/ui/core/widgets/view_model_scope.dart';
import 'package:prepay_app/ui/point_history/view_models/point_history_view_model.dart';
import 'package:prepay_app/ui/point_history/widgets/point_history_screen.dart';

// 서버 PointHistoryController와 같은 모양의 응답
const _chargesJson = {
  'balance': 280000,
  'items': [
    {
      'id': 5,
      'store_id': 1,
      'store_name': '행복식당 1',
      'amount': 50000,
      'paid_won': 47500,
      'charged_at': '2026-11-13T12:00:00+09:00',
    },
  ],
};

const _usesJson = {
  'balance': 280000,
  'items': [
    {
      'id': 7,
      'store_id': 1,
      'store_name': '행복식당 1',
      'visit_number': 13,
      'method': 'customer',
      'amount': 30000,
      'charge_amount': 20000,
      'shared_amount': 0,
      'service_amount': 10000,
      'used_at': '2026-11-03T23:00:00+09:00',
    },
  ],
};

const _serviceJson = {
  'balance': 10000,
  'items': [
    {
      'id': 3,
      'store_id': 1,
      'store_name': '행복식당 1',
      'amount': 10000,
      'status': 'usable',
      'days_left': 100,
      'received_at': '2026-11-15T16:30:00+09:00',
    },
    {
      'id': 2,
      'store_id': 2,
      'store_name': '하루카페 2',
      'amount': 5000,
      'status': 'used_up',
      'days_left': 12,
      'received_at': '2026-11-10T10:00:00+09:00',
    },
    {
      'id': 1,
      'store_id': 2,
      'store_name': '하루카페 2',
      'amount': 3000,
      'status': 'expired',
      'days_left': null,
      'received_at': '2026-11-01T10:00:00+09:00',
    },
  ],
};

// 서버로 간 요청을 requests에 모으고, 응답은 json으로 준다
PointRepository _repository(Object json, List<http.Request> requests) =>
    PointRepository(
      apiClient: ApiClient(
        baseUrl: 'http://test',
        client: MockClient((request) async {
          requests.add(request);
          return http.Response.bytes(utf8.encode(jsonEncode(json)), 200);
        }),
      ),
    );

// 한글이 들어 있어서 utf8 바이트로 응답을 만든다
http.Response _json(Object json, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(json)), status);

// 요청 경로에 맞는 내역 응답
Future<http.Response> _history(http.Request request) async =>
    _json(switch (request.url.pathSegments.last) {
      'charges' => _chargesJson,
      'uses' => _usesJson,
      _ => _serviceJson,
    });

// 시안과 같은 390x844 화면에 포인트 내역을 띄운다. 이번 달은 2026년 11월
// /wallet은 들어온 곳을 확인하려고 둔 빈 화면이다
Future<GoRouter> _pumpHistory(
  WidgetTester tester,
  Future<http.Response> Function(http.Request) handler, {
  String location = '/wallet',
}) async {
  tester.view.physicalSize = Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final pointRepository = PointRepository(
    apiClient: ApiClient(baseUrl: 'http://test', client: MockClient(handler)),
  );
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/wallet',
        builder: (context, state) => Scaffold(body: Text('내 가게')),
        routes: [
          GoRoute(
            path: 'history/:tab',
            builder: (context, state) => ViewModelScope(
              key: ValueKey(state.uri),
              create: () => PointHistoryViewModel(
                pointRepository: pointRepository,
                tab: HistoryTab.fromName(state.pathParameters['tab']),
                period: HistoryPeriod.fromQuery(
                  state.uri.queryParameters,
                  fallback: HistoryPeriod(2026, 11),
                ),
              )..load(),
              builder: (viewModel) => PointHistoryScreen(viewModel: viewModel),
            ),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(theme: appTheme, routerConfig: router),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  test('결제 내역 응답을 앱 모델로 바꾸고 기간을 쿼리로 보낸다', () async {
    final requests = <http.Request>[];
    final page = await _repository(
      _chargesJson,
      requests,
    ).getChargeHistory(HistoryPeriod(2026, 11));

    expect(requests.single.url.path, '/api/history/charges');
    expect(requests.single.url.queryParameters, {
      'year': '2026',
      'month': '11',
    });

    expect(page.balance, 280000);
    final record = page.items.single;
    expect(record.storeName, '행복식당 1');
    expect(record.amount, 50000);
    expect(record.paidWon, 47500);
    expect(record.chargedAt, DateTime.parse('2026-11-13T12:00:00+09:00'));
  });

  test('가게 이용 내역 응답을 앱 모델로 바꾼다', () async {
    final requests = <http.Request>[];
    final page = await _repository(
      _usesJson,
      requests,
    ).getUseHistory(HistoryPeriod(2026, 11));

    expect(requests.single.url.path, '/api/history/uses');

    final record = page.items.single;
    expect(record.visitNumber, 13);
    expect(record.method, UseMethod.customer);
    expect(record.amount, 30000);
    expect(record.chargeAmount, 20000);
    expect(record.sharedAmount, 0);
    expect(record.serviceAmount, 10000);
    expect(record.usedAt, DateTime.parse('2026-11-03T23:00:00+09:00'));
  });

  test('서비스포인트 응답의 상태를 앱 모델로 바꾼다', () async {
    final requests = <http.Request>[];
    final page = await _repository(
      _serviceJson,
      requests,
    ).getServiceHistory(HistoryPeriod(2026, 11));

    expect(requests.single.url.path, '/api/history/service');
    expect(page.balance, 10000);
    expect(page.items.map((record) => record.status), [
      ServiceStatus.usable,
      ServiceStatus.usedUp,
      ServiceStatus.expired,
    ]);
    expect(page.items.map((record) => record.daysLeft), [100, 12, null]);
  });

  test('연도별이면 month를 보내지 않는다', () async {
    final requests = <http.Request>[];
    await _repository(
      _chargesJson,
      requests,
    ).getChargeHistory(HistoryPeriod(2025));

    expect(requests.single.url.queryParameters, {'year': '2025'});
  });

  test('기간은 쿼리에서 읽고, 날짜 형식이 맞지않으면 이번 달로 조회한다', () {
    final thisMonth = HistoryPeriod(2026, 11);
    HistoryPeriod read(Map<String, String> query) =>
        HistoryPeriod.fromQuery(query, fallback: thisMonth);

    expect(read({}), thisMonth);
    expect(read({'year': '2026', 'month': '13'}), thisMonth);
    expect(read({'year': 'x'}), thisMonth);
    expect(read({'year': '2025', 'month': '3'}), HistoryPeriod(2025, 3));
    expect(read({'year': '2025'}), HistoryPeriod(2025));

    expect(HistoryPeriod(2025).label, '2025년');
    expect(HistoryPeriod(2026, 11).label, '2026년 11월');
    expect(HistoryPeriod(2026, 11).toQuery(), {'year': '2026', 'month': '11'});
  });

  test('탭 이름을 잘 못 입력하면 결제 내역 탭으로 이동', () {
    expect(HistoryTab.fromName('service'), HistoryTab.service);
    expect(HistoryTab.fromName('nope'), HistoryTab.charges);
    expect(HistoryTab.fromName(null), HistoryTab.charges);
  });

  testWidgets('경로의 탭으로 열고 결제 내역을 보여 준다', (tester) async {
    await _pumpHistory(
      tester,
      _history,
      location: '/wallet/history/charges?year=2026&month=11',
    );

    expect(find.text('포인트 내역'), findsOneWidget);
    expect(find.text('충전포인트'), findsOneWidget);
    expect(find.text('공유포인트'), findsOneWidget);
    expect(find.text('서비스포인트'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('충전포인트')),
      isSemantics(isSelected: true),
    );
    expect(
      tester.getSemantics(find.text('결제 내역')),
      isSemantics(isSelected: true),
    );

    expect(find.text('쓸 수 있는 충전포인트'), findsOneWidget);
    expect(find.text('280,000'), findsOneWidget);

    expect(find.text('행복식당 1'), findsOneWidget);
    expect(find.text('결제 완료'), findsOneWidget);
    expect(find.text('충전 포인트'), findsOneWidget);
    expect(find.text('50,000P'), findsOneWidget);
    expect(find.text('결제 금액'), findsOneWidget);
    expect(find.text('47,500원'), findsOneWidget);
    expect(find.text('결제 일시'), findsOneWidget);
    expect(find.text('2026.11.13 12:00'), findsOneWidget);
    // 결제 내역은 날짜로 묶지 않는다.
    expect(find.textContaining('11월 13일'), findsNothing);
  });

  testWidgets('탭을 바꾸면 기간을 그대로 남기고, 뒤로 한 번이면 들어온 곳이다', (tester) async {
    final requests = <http.Request>[];
    final router = await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    });

    router.push(Routes.history(HistoryTab.charges, HistoryPeriod(2026, 10)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('가게 이용 내역'));
    await tester.pumpAndSettle();
    expect(requests.last.url.path, '/api/history/uses');
    expect(requests.last.url.queryParameters, {'year': '2026', 'month': '10'});

    await tester.tap(find.text('서비스포인트'));
    await tester.pumpAndSettle();
    expect(requests.last.url.path, '/api/history/service');
    expect(requests.last.url.queryParameters, {'year': '2026', 'month': '10'});
    expect(find.text('쓸 수 있는 서비스포인트'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('내 가게'), findsOneWidget);
  });

  testWidgets('결제 내역이 없으면 빈 화면을 보여 준다', (tester) async {
    await _pumpHistory(
      tester,
      (_) async => _json({'balance': 0, 'items': []}),
      location: '/wallet/history/charges',
    );

    expect(find.text('이 기간에 결제한 내역이 없어요'), findsOneWidget);
    expect(find.text('기간을 바꿔 보세요'), findsOneWidget);
  });

  testWidgets('불러오지 못하면 다시 불러올 수 있다', (tester) async {
    var calls = 0;
    await _pumpHistory(
      tester,
      (request) async => ++calls == 1 ? _json({}, 500) : _history(request),
      location: '/wallet/history/charges',
    );
    expect(find.byType(LoadError), findsOneWidget);

    await tester.tap(find.text('다시 불러오기'));
    await tester.pumpAndSettle();
    expect(find.byType(LoadError), findsNothing);
    expect(find.text('행복식당 1'), findsOneWidget);
  });

  testWidgets('공유포인트 탭은 서버를 부르지 않고 빈 화면이다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/shared');

    expect(find.text('쓸 수 있는 공유포인트'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('아직 공유포인트가 없어요'), findsOneWidget);
    expect(find.text('공유 기능을 준비하고 있어요'), findsOneWidget);
    // 결제 내역 | 가게 이용 내역은 충전포인트 탭에만 있다
    expect(find.text('결제 내역'), findsNothing);
    expect(requests, isEmpty);
  });
}
