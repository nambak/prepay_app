import '../../domain/models/point.dart';
import '../../domain/models/store.dart';
import '../services/api_client.dart';

class PointRepository {
  PointRepository({required this._apiClient});

  final ApiClient _apiClient;

  Future<Wallet> getWallet() async =>
      _walletFromJson(await _apiClient.getWallet());
}

// 서버 JSON(saved_won 처럼 snake_case)을 앱 모델로 바꾼다.
Wallet _walletFromJson(JsonMap json) => Wallet(
  charge: json['charge'] as int,
  shared: json['shared'] as int,
  service: json['service'] as int,
  savedWon: json['saved_won'] as int,
  stores: [
    for (final store in json['stores'] as List)
      _storeFromJson(store as JsonMap),
  ],
);

StoreWallet _storeFromJson(JsonMap json) => StoreWallet(
  id: '${json['id']}',
  // 서버는 숫자, 앱은 문자열
  name: json['name'] as String,
  // 앱이 모르는 업종이 오면 일반 가게로 보여줌
  kind: StoreKind.fromName(json['kind']),
  visitCount: json['visit_count'] as int,
  savedWon: json['saved_won'] as int,
  items: [
    for (final item in json['items'] as List)
      _pointItemFromJson(item as JsonMap),
  ],
);

PointItem _pointItemFromJson(JsonMap json) => PointItem(
  PointType.values.byName(json['type'] as String),
  json['amount'] as int,
  daysLeft: json['days_left'] as int?,
);
