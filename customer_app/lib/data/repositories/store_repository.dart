import '../../domain/models/store.dart';
import '../services/api_client.dart';

class StoreRepository {
  StoreRepository({required this._apiClient});

  final ApiClient _apiClient;

  Future<List<StoreSummary>> getStores() async {
    final json = await _apiClient.getStores();
    return [
      for (final store in json['stores'] as List)
        _summaryFromJson(store as JsonMap),
    ];
  }

  Future<StoreDetail> getStore(String id) async =>
      _detailFromJson(await _apiClient.getStore(id));
}

// 서버 JSON(snake_case)를 앱 모델로 바꾼다. id는 서버는 숫자, 앱은 문자열.
StoreSummary _summaryFromJson(JsonMap json) => StoreSummary(
  id: '${json['id']}',
  name: json['name'] as String,
  kind: StoreKind.fromName(json['kind']),
  maxDiscountRate: json['max_discount_rate'] as int?,
);

StoreDetail _detailFromJson(JsonMap json) => StoreDetail(
  id: '${json['id']}',
  name: json['name'] as String,
  kind: StoreKind.fromName(json['kind']),
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  chargeProducts: [
    for (final product in json['charge_products'] as List)
      _chargeProductFromJson(product as JsonMap),
  ],
);

ChargeProduct _chargeProductFromJson(JsonMap json) => ChargeProduct(
  amount: json['amount'] as int,
  priceWon: json['price_won'] as int,
  discountRate: json['discount_rate'] as int,
);
