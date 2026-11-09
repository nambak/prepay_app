import 'dart:convert';

import 'package:http/http.dart' as http;

typedef JsonMap = Map<String, dynamic>;

// 서버가 2xx가 아닌 응답을 준 경우. 상태 코드로 무엇이 잘못됐는지 알 수 있다.
class ApiException implements Exception {
  const ApiException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'ApiException: HTTP $statusCode';
}

// 서버(server/)의 api 호출. JSON을 주고받기만 하고, 앱 모델로 바꾸는 것은 repository가 한다.
class ApiClient {
  ApiClient({required this._baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  static const _timeout = Duration(seconds: 10);

  final String _baseUrl;
  final http.Client _client;

  // 로그인해서 받은 토큰. 있으면 모든 요청에 붙인다.
  String? token;

  // 토큰이 있는데 서버가 401을 응답한 경우(토큰이 지워졌거나 만료된 경우)
  void Function()? onUnauthorized;

  // 요청 공통
  Future<JsonMap> _get(String path) async => _decode(
    await _client.get(_uri(path), headers: _headers()).timeout(_timeout),
  );

  Future<JsonMap> _post(String path, [Map<String, Object?>? body]) async =>
      _decode(
        await _client
            .post(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}))
            .timeout(_timeout),
      );

  Future<JsonMap> _delete(String path) async => _decode(
    await _client.delete(_uri(path), headers: _headers()).timeout(_timeout),
  );

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Map<String, String> _headers() => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  JsonMap _decode(http.Response response) {
    if (response.statusCode == 401 && token != null) onUnauthorized?.call();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode);
    }

    // 로그아웃(204)처럼 내용이 없는 응답
    if (response.bodyBytes.isEmpty) return {};

    // 서버가 charset을 안 붙여도 한글이 깨지지 않게 바이트에서 직접 읽는다.
    return jsonDecode(utf8.decode(response.bodyBytes)) as JsonMap;
  }

  // ── 로그인·회원 ──

  // 성공하면 토큰을 돌려준다.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final json = await _post('/api/login', {
      'email': email,
      'password': password,
      'device_name': 'customer_app',
    });

    return json['token'] as String;
  }

  Future<void> logout() => _post('/api/logout');

  Future<void> withdraw() => _delete('/api/user');

  // ── 포인트 ──

  Future<JsonMap> getWallet() => _get('/api/wallet');

  // ── 가게 ──

  Future<JsonMap> getStores() => _get('/api/stores');

  Future<JsonMap> getStore(String id) => _get('/api/stores/$id');
}
