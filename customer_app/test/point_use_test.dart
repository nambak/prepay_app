import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';

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

void main() {
  test('쓰기 응답을 앱 모델로 바꾼다', () async {
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
}
