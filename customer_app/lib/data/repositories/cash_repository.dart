import 'package:prepay_app/data/services/api_client.dart';

import '../../domain/models/cash.dart';
import '../../domain/models/store.dart';

class CashRepository {
  CashRepository({required this._apiClient});

  final ApiClient _apiClient;

  Future<Wallet> getWallet() async =>
      _walletFromJson(await _apiClient.getWallet());
}

// 서버 JSON(saved_won 처럼 snake_case)을 앱 모델로 바꾼다.
Wallet _walletFromJson(Map<String, dynamic> json) => Wallet(
  charge: json['charge'] as int,
  shared: json['shared'] as int,
  service: json['service'] as int,
  savedWon: json['saved_won'] as int,
  stores: [
    for (final store in json['stores'] as List)
      _storeFromJson(store as Map<String, dynamic>),
  ],
);

StoreWallet _storeFromJson(Map<String, dynamic> json) => StoreWallet(
  id: '${json['id']}',
  // 서버는 숫자, 앱은 문자열
  name: json['name'] as String,
  // 앱이 모르는 업종이 오면 일반 가게로 보여줌
  kind: StoreKind.values.asNameMap()[json['kind']] ?? StoreKind.shop,
  visitCount: json['visit_count'] as int,
  savedWon: json['saved_won'] as int,
  items: [
    for (final item in json['items'] as List)
      _cashItemFromJson(item as Map<String, dynamic>),
  ],
);

CashItem _cashItemFromJson(Map<String, dynamic> json) => CashItem(
  CashType.values.byName(json['type'] as String),
  json['amount'] as int,
  daysLeft: json['days_left'] as int,
);
