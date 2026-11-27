import 'dart:async';
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
import 'package:prepay_app/ui/core/format.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/widgets/load_error.dart';
import 'package:prepay_app/ui/core/widgets/view_model_scope.dart';
import 'package:prepay_app/ui/point_history/view_models/point_history_view_model.dart';
import 'package:prepay_app/ui/point_history/widgets/history_tabs.dart';
import 'package:prepay_app/ui/point_history/widgets/point_history_screen.dart';
import 'package:prepay_app/ui/point_history/widgets/record_badge.dart';
import 'package:prepay_app/ui/point_history/widgets/service_record_card.dart';
import 'package:prepay_app/ui/point_history/widgets/use_record_card.dart';

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

// 결제 내역 한 건. 거르기 줄 테스트에서 가게와 날짜만 바꿔 쓴다
Map<String, Object> _charge(int id, String storeName, String chargedAt) => {
  'id': id,
  'store_id': id,
  'store_name': storeName,
  'amount': 50000,
  'paid_won': 47500,
  'charged_at': chargedAt,
};

// 최신 순: 하루카페2(11월 20일), 행복식당 1(11월 13일)
final _twoChargesJson = {
  'balance': 280000,
  'items': [
    _charge(6, '하루카페2', '2026-11-20T12:00:00+09:00'),
    _charge(5, '행복식당 1', '2026-11-13T12:00:00+09:00'),
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
                thisMonth: HistoryPeriod(2026, 11),
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
    // 서버는 네 자리 연도만 받는다
    expect(read({'year': '26', 'month': '11'}), thisMonth);
    expect(read({'year': '20260'}), thisMonth);

    expect(HistoryPeriod(2025).label, '2025년');
    expect(HistoryPeriod(2026, 11).label, '2026년 11월');
    expect(HistoryPeriod(2026, 11).toQuery(), {'year': '2026', 'month': '11'});
  });

  test('날짜와 머리글은 한국 날짜와 요일이다', () {
    expect(
      formatDayHeader(DateTime.parse('2026-11-02T15:30:00Z')),
      '11월 3일 (화)',
    );
    expect(
      formatDayHeader(DateTime.parse('2026-11-01T12:00:00+09:00')),
      '11월 1일 (일)',
    );
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
    // 탭 줄의 밑줄은 화면 폭을 채운다
    expect(tester.getSize(find.byType(HistoryTabs)).width, 390);

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

    await tester.tap(find.text('서비스포인트').first);
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

  testWidgets('가게 이용 내역을 한국 날짜로 묶어 보여 준다', (tester) async {
    Map<String, Object> use(int visit, String method, String usedAt) => {
      'id': visit,
      'store_id': 1,
      'store_name': '행복식당 1',
      'visit_number': visit,
      'method': method,
      'amount': 30000,
      'charge_amount': 20000,
      'shared_amount': 0,
      'service_amount': 10000,
      'used_at': usedAt,
    };
    await _pumpHistory(
      tester,
      (_) async => _json({
        'balance': 280000,
        'items': [
          use(13, 'customer', '2026-11-03T23:00:00+09:00'),
          // UTC로는 11월 2일 이지만 한국 시각으로는 11월 3일이다
          use(12, 'store', '2026-11-03T00:30:00+09:00'),
          use(11, 'customer', '2026-11-01T12:00:00+09:00'),
        ],
      }),
      location: '/wallet/history/uses',
    );

    expect(find.text('11월 3일 (화)'), findsOneWidget);
    expect(find.text('11월 1일 (일)'), findsOneWidget);
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(top('11월 3일 (화)'), lessThan(top('2026.11.03 00:30')));
    expect(top('2026.11.03 00:30'), lessThan(top('11월 1일 (일)')));
    expect(top('11월 1일 (일)'), lessThan(top('2026.11.01 12:00')));

    final card = find.byType(UseRecordCard).first;
    Finder inCard(String text) =>
        find.descendant(of: card, matching: find.text(text));
    expect(inCard('행복식당 1'), findsOneWidget);
    expect(inCard('13번째 이용'), findsOneWidget);
    expect(inCard('고객 차감'), findsOneWidget);
    expect(inCard('쓴 포인트'), findsOneWidget);
    expect(inCard('30,000P'), findsOneWidget);
    expect(inCard('충전포인트'), findsOneWidget);
    expect(inCard('20,000'), findsOneWidget);
    expect(inCard('공유포인트'), findsOneWidget);
    expect(inCard('0'), findsOneWidget);
    expect(inCard('서비스포인트'), findsOneWidget);
    expect(inCard('10,000'), findsOneWidget);
    expect(inCard('이용 일시'), findsOneWidget);
    expect(inCard('2026.11.03 23:00'), findsOneWidget);

    // 가게 차감은 QR 차감과 나누기 전이라 배지를 그리지 않는다
    expect(find.text('고객 차감'), findsNWidgets(2));
    expect(find.text('가게 차감'), findsNothing);
    // 이용 메뉴와 리뷰는 아직 없다
    expect(find.text('이용 메뉴 보기'), findsNothing);
    expect(find.text('리뷰 쓰기'), findsNothing);
  });

  testWidgets('서비스포인트 배지는 남은 날, 모두 씀, 기한 지남이다', (tester) async {
    Map<String, Object?> lot(int id, String status, int? daysLeft) => {
      'id': id,
      'store_id': 1,
      'store_name': '행복식당 1',
      'amount': 10000,
      'status': status,
      'days_left': daysLeft,
      'received_at': '2026-11-15T16:30:00+09:00',
    };
    await _pumpHistory(
      tester,
      (_) async => _json({
        'balance': 20000,
        'items': [
          lot(5, 'usable', 100),
          lot(4, 'used_up', 12),
          lot(3, 'expired', null),
          // 다 쓰고 기한도 지났다
          lot(2, 'used_up', null),
          lot(1, 'usable', null),
        ],
      }),
      location: '/wallet/history/service',
    );

    expect(find.text('쓸 수 있는 서비스포인트'), findsOneWidget);
    expect(find.text('20,000'), findsOneWidget);
    expect(
      find.text('서비스포인트는 가게가 감사의 뜻으로 드리는 포인트예요. 기한 안에 써 주세요.'),
      findsOneWidget,
    );

    final cards = find.byType(ServiceRecordCard);
    List<String> badges(int index) => tester
        .widgetList<RecordBadge>(
          find.descendant(
            of: cards.at(index),
            matching: find.byType(RecordBadge),
          ),
        )
        .map((badge) => badge.text)
        .toList();
    expect(cards, findsNWidgets(5));
    expect(badges(0), ['D-100']);
    expect(badges(1), ['D-12', '모두 씀']);
    expect(badges(2), ['기한 지남']);
    expect(badges(3), ['모두 씀']);
    expect(badges(4), isEmpty);

    Finder inCard(String text) =>
        find.descendant(of: cards.first, matching: find.text(text));
    expect(inCard('행복식당 1'), findsOneWidget);
    expect(inCard('받은 포인트'), findsOneWidget);
    expect(inCard('10,000P'), findsOneWidget);
    expect(inCard('받은 날 2026.11.15 16:30'), findsOneWidget);
    // 서비스포인트는 날짜로 묶지 않는다.
    expect(find.textContaining('11월 15일'), findsNothing);
  });

  testWidgets('글자를 크게 해도 위쪽 탭을 모두 누를 수 있다', (tester) async {
    // 1.2배면 세 탭이 한 줄에 들어가지 않는다
    tester.platformDispatcher.textScaleFactorTestValue = 1.2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges');

    await tester.ensureVisible(find.text('서비스포인트'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('서비스포인트'));
    await tester.pumpAndSettle();
    expect(requests.last.url.path, '/api/history/service');
  });

  // 거르기 줄의 기간 버튼을 눌러 기간 시트를 연다
  Future<void> openPeriodSheet(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('기간 시트에서 달을 고르면 그 달로 다시 불러온다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges');

    await openPeriodSheet(tester, '2026년 11월');
    await tester.tap(find.text('10월'));
    await tester.pumpAndSettle();

    expect(requests, hasLength(2));
    expect(requests.last.url.queryParameters, {'year': '2026', 'month': '10'});
    expect(find.text('2026년 10월'), findsOneWidget);
  });

  testWidgets('이번 달 뒤의 달과 다음 해는 고를 수 없다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges');

    await openPeriodSheet(tester, '2026년 11월');
    await tester.tap(find.text('12월'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('다음 해'));
    await tester.pumpAndSettle();

    expect(requests, hasLength(1));
    // 시트는 그대로 열려 있고 해도 그대로다
    expect(find.text('12월'), findsOneWidget);
    expect(find.text('2026년'), findsOneWidget);
  });

  testWidgets('연도별은 해를 고르고 확인을 누르면 그해로 다시 불러온다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges');

    await openPeriodSheet(tester, '2026년 11월');
    await tester.tap(find.text('연도별'));
    await tester.pumpAndSettle();
    expect(find.text('1월'), findsNothing);

    await tester.tap(find.byTooltip('이전 해'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(requests.last.url.queryParameters, {'year': '2025'});
    expect(find.text('2025년'), findsOneWidget);
  });

  testWidgets('달을 누르지 않고 시트를 닫으면 기간이 그대로다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges');

    await openPeriodSheet(tester, '2026년 11월');
    await tester.tap(find.byTooltip('이전 해'));
    await tester.pumpAndSettle();
    expect(find.text('2025년'), findsOneWidget);

    // 시트 바깥을 눌러 닫는다
    await tester.tapAt(Offset(195, 100));
    await tester.pumpAndSettle();
    expect(requests, hasLength(1));
    expect(find.text('2026년 11월'), findsOneWidget);

    // 다시 열면 지금 고른 기간의 해로 열린다
    await openPeriodSheet(tester, '2026년 11월');
    expect(find.text('2026년'), findsOneWidget);
  });

  testWidgets('가게 이름으로 찾으면 그 가게 기록만 보이고 서버를 다시 부르지 않는다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) async {
      requests.add(request);
      return _json(_twoChargesJson);
    }, location: '/wallet/history/charges');

    await tester.tap(find.byTooltip('가게 이름으로 찾기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '하루');
    await tester.pump();
    expect(find.text('하루카페2'), findsOneWidget);
    expect(find.text('행복식당 1'), findsNothing);

    await tester.enterText(find.byType(TextField), '없는');
    await tester.pump();
    expect(find.text("'없는' 검색 결과가 없어요"), findsOneWidget);
    expect(find.text('다른 가게 이름으로 찾아보세요'), findsOneWidget);
    expect(requests, hasLength(1));

    // 닫으면 찾은 글자를 지우고 모두 보여 준다
    await tester.tap(find.byTooltip('가게 찾기 닫기'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(find.text('하루카페2'), findsOneWidget);
    expect(find.text('행복식당 1'), findsOneWidget);
  });

  testWidgets('정렬을 오래된 순으로 바꾸면 순서가 뒤집힌다', (tester) async {
    await _pumpHistory(
      tester,
      (_) async => _json(_twoChargesJson),
      location: '/wallet/history/charges',
    );
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(top('하루카페2'), lessThan(top('행복식당 1')));

    await tester.tap(find.text('최신 순'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('오래된 순'));
    await tester.pumpAndSettle();

    expect(top('행복식당 1'), lessThan(top('하루카페2')));
    expect(find.text('오래된 순'), findsOneWidget);
    expect(find.text('최신 순'), findsNothing);
  });

  testWidgets('기간을 바꾸는 동안 이전 목록을 감춘다', (tester) async {
    final october = Completer<void>();
    var calls = 0;
    await _pumpHistory(tester, (request) async {
      if (++calls == 1) return _history(request);
      await october.future;
      return _json({
        'balance': 280000,
        'items': [_charge(4, '시월식당', '2026-10-20T12:00:00+09:00')],
      });
    }, location: '/wallet/history/charges');

    await openPeriodSheet(tester, '2026년 11월');
    await tester.tap(find.text('10월'));
    // 불러오는 동안 도는 표시가 있어서 pumpAndSettle 대신 시트가 닫힐 만큼만 넘긴다
    await tester.pump();
    await tester.pump(Duration(milliseconds: 500));
    expect(find.text('행복식당 1'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    october.complete();
    await tester.pumpAndSettle();
    expect(find.text('시월식당'), findsOneWidget);
    expect(find.text('2026년 10월'), findsOneWidget);
  });

  testWidgets('가게 찾기 칸은 목록을 내렸다 올려도 입력한 글자와 함께 남아 있다', (tester) async {
    await _pumpHistory(
      tester,
      (_) async => _json({
        'balance': 280000,
        'items': [
          for (var id = 20; id > 0; id--)
            _charge(
              id,
              '하루카페2',
              '2026-11-${id.toString().padLeft(2, '0')}T12:00:00+09:00',
            ),
        ],
      }),
      location: '/wallet/history/charges',
    );

    await tester.tap(find.byTooltip('가게 이름으로 찾기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '하루');
    await tester.pump();
    // 입력칸에 포커스가 있으면 목록이 거르기 줄을 남겨 두므로 포커스를 뺀다
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.drag(find.byType(ListView), Offset(0, -3000));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), Offset(0, 3000));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, '하루'), findsOneWidget);
  });

  testWidgets('경로의 기간이 이번 달보다 뒤면 기간 시트는 이번 해로 열린다', (tester) async {
    final requests = <http.Request>[];
    await _pumpHistory(tester, (request) {
      requests.add(request);
      return _history(request);
    }, location: '/wallet/history/charges?year=2027&month=2');

    await openPeriodSheet(tester, '2027년 2월');
    expect(find.text('2026년'), findsOneWidget);

    // 이번 해라서 이번 달 뒤의 달은 그대로 고를 수 없다
    await tester.tap(find.text('12월'));
    await tester.pumpAndSettle();
    expect(requests, hasLength(1));
  });
}
