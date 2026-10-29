import 'dart:convert';

import 'package:http/http.dart' as http;

// 서버(server/)의 api 호출, JSON을 주고 받기만 하고, 앱 모델로 바꾸는 것은 repository가 한다.
class ApiClient {
  ApiClient({required this._baseUrl, http.Client? client}): _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  Future<Map<String, dynamic>> getWallet() => _getJson('/api/wallet');

  Future<Map<String, dynamic>> _getJson(String path) async {
    final response = await _client
        .get(
          Uri.parse('$_baseUrl$path'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}', response.request?.url);
    }

    // 서버가 charset을 안 붙여도 한글이 까지지 않게 바이트에서 직접 읽는다.
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
