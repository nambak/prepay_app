import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/services/api_client.dart';

void main() {
  test('지갑 주소로 JSON을 요청하고 한글을 그대로 읽는다', () async {
    late http.Request sent;
    final apiClient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        sent = request;
        // Laravel처럼 charset없이 와도 한글이 깨지지 않아야 한다.
        return http.Response.bytes(
          utf8.encode(jsonEncode({'name': '행복식당'})),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final json = await apiClient.getWallet();

    expect(sent.method, 'GET');
    expect(sent.url.toString(), 'http://test/api/wallet');
    expect(sent.headers['Accept'], 'application/json');
    expect(json['name'], '행복식당');
  });

  test('200이 아니면 예외를 던진다', () async {
    final apiclient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => http.Response('', 500)),
    );

    await expectLater(
      apiclient.getWallet(),
      throwsA(isA<http.ClientException>()),
    );
  });
}
