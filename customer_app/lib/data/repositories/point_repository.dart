import '../../domain/models/charge.dart';
import '../../domain/models/point.dart';
import '../../domain/models/point_history.dart';
import '../../domain/models/point_use.dart';
import '../../domain/models/store.dart';
import '../services/api_client.dart';

class PointRepository {
  new({required this._apiClient});

  final ApiClient _apiClient;

  Future<Wallet> getWallet() async =>
      _walletFromJson(await _apiClient.getWallet());

  // 포인트와 결제 금액은 서버가 충전 상품으로 다시 계산해서 돌려준다.
  Future<ChargeReceipt> charge(ChargeOrder order) async {
    final json = await _apiClient.charge(order.store.id, [
      for (final line in order.lines)
        {'charge_product_id': line.product.id, 'quantity': line.quantity},
    ]);

    return ChargeReceipt(
      storeName: json['store_name'] as String,
      amount: json['amount'] as int,
      paidWon: json['paid_won'] as int,
      chargedAt: DateTime.parse(json['charged_at'] as String),
    );
  }

  // 고객차감: 서버가 바로 차감하고, 어느 포인트에서 얼마를 뺐는지 돌려준다
  Future<PointUseReceipt> usePoints(int storeId, int amount) async {
    final json = await _apiClient.usePoints(storeId, amount);

    return PointUseReceipt(
      storeName: json['store_name'] as String,
      amount: json['amount'] as int,
      serviceAmount: json['service_amount'] as int,
      chargeAmount: json['charge_amount'] as int,
      balance: json['balance'] as int,
      visitCount: json['visit_count'] as int,
      usedAt: DateTime.parse(json['used_at'] as String),
    );
  }

  // 포인트 내역: 기간 안의 기록을 최신 순으로 받는다
  Future<HistoryPage<ChargeRecord>> getChargeHistory(HistoryPeriod period) =>
      _getHistory('charges', period, _chargeRecordFromJson);

  Future<HistoryPage<UseRecord>> getUseHistory(HistoryPeriod period) =>
      _getHistory('uses', period, _useRecordFromJson);

  Future<HistoryPage<ServiceRecord>> getServiceHistory(HistoryPeriod period) =>
      _getHistory('service', period, _serviceRecordFromJson);

  Future<HistoryPage<T>> _getHistory<T extends HistoryRecord>(
    String kind,
    HistoryPeriod period,
    T Function(JsonMap json) fromJson,
  ) async {
    final json = await _apiClient.getHistory(
      kind,
      year: period.year,
      month: period.month,
    );

    return HistoryPage(
      balance: json['balance'] as int,
      items: [
        for (final item in json['items'] as List) fromJson(item as JsonMap),
      ],
    );
  }
}

// 서버 JSON(saved_won 처럼 snake_case)을 앱 모델로 바꾼다
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
  id: json['id'] as int,
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

ChargeRecord _chargeRecordFromJson(JsonMap json) => ChargeRecord(
  id: json['id'] as int,
  storeName: json['store_name'] as String,
  amount: json['amount'] as int,
  paidWon: json['paid_won'] as int,
  chargedAt: DateTime.parse(json['charged_at'] as String),
);

UseRecord _useRecordFromJson(JsonMap json) => UseRecord(
  id: json['id'] as int,
  storeName: json['store_name'] as String,
  visitNumber: json['visit_number'] as int,
  method: UseMethod.fromName(json['method'] as String),
  amount: json['amount'] as int,
  chargeAmount: json['charge_amount'] as int,
  sharedAmount: json['shared_amount'] as int,
  serviceAmount: json['service_amount'] as int,
  usedAt: DateTime.parse(json['used_at'] as String),
);

ServiceRecord _serviceRecordFromJson(JsonMap json) => ServiceRecord(
  id: json['id'] as int,
  storeName: json['store_name'] as String,
  amount: json['amount'] as int,
  // 서버 이름은 snake_case(used_up)
  status: switch (json['status']) {
    'used_up' => ServiceStatus.usedUp,
    'expired' => ServiceStatus.expired,
    _ => ServiceStatus.usable,
  },
  daysLeft: json['days_left'] as int?,
  receivedAt: DateTime.parse(json['received_at'] as String),
);
