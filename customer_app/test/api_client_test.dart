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

  test('200이 아니면 상태 코드를 담은 예외를 던진다', () async {
    final apiclient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => http.Response('', 500)),
    );

    await expectLater(
      apiclient.getWallet(),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
      ),
    );
  });

  test('로그인하면 토큰을 돌려주고, 그 뒤 요청에는 토큰을 붙인다', () async {
    final sent = <http.Request>[];
    final apiClient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((request) async {
        sent.add(request);
        return request.url.path == '/api/login'
            ? http.Response(jsonEncode({'token': '1|abc'}), 200)
            : http.Response('{}', 200);
      }),
    );

    String email = 'hana@email.com';
    String password = 'password1234';

    apiClient.token = await apiClient.login(
        email: email,
        password: password
    );
    await apiClient.getWallet();

    expect(sent[0].method, 'POST');
    expect(jsonDecode(sent[0].body), {
      'email': email,
      'password': password,
      'device_name': 'customer_app',
    });
    expect(sent[0].headers['Authorization'], isNull);
    expect(sent[1].headers['Authorization'], 'Bearer 1|abc');
  });

  test('내용이 없는 응답(204)도 오류 없이 받는다', () async {
    final apiClient = ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => http.Response('', 204)),
    );

    await expectLater(apiClient.logout(), completes);
  });
}
