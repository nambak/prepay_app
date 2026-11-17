import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/domain/models/point_history.dart';

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
}
