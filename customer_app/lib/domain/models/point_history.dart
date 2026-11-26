import 'point.dart';

// 포인트 내역의 탭. 이름이 경로 /wallet/history/:tab에 들어간다
enum HistoryTab {
  charges, // 결제 내역
  uses, // 가게 이용 내역
  shared, // 공유포인트
  service; // 서비스포인트

  // 모르는 이름이면 결제 내역
  static HistoryTab fromName(String? name) =>
      values.asNameMap()[name] ?? charges;

  // 내 가게의 포인트 종류를 눌러 들어올 때 열 탭
  static HistoryTab of(PointType type) => switch (type) {
    PointType.charge => charges,
    PointType.shared => shared,
    PointType.service => service,
  };
}

// 내역을 볼 기간. month가 없으면 그 해 전체
class HistoryPeriod {
  const new(this.year, [this.month]);

  // 그 시각이 있는 달. 한국 시각을 넘긴다
  new monthOf(DateTime time) : year = time.year, month = time.month;

  final int year;
  final int? month;

  // 경로의 ?year=&month=. 값이 틀리면 fallback
  static HistoryPeriod fromQuery(
    Map<String, String> query, {
    required HistoryPeriod fallback,
  }) {
    final year = int.tryParse(query['year'] ?? '');
    // 서버는 네 자리 연도만 받는다
    if (year == null || year < 1000 || year > 9999) return fallback;

    final month = query['month'];
    if (month == null) return HistoryPeriod(year);

    final m = int.tryParse(month);
    return m != null && m >= 1 && m <= 12 ? HistoryPeriod(year, m) : fallback;
  }

  Map<String, String> toQuery() => {
    'year': '$year',
    if (month != null) 'month': '$month',
  };

  String get label => month == null ? '$year년' : '$year년 $month월';

  @override
  bool operator ==(Object other) =>
      other is HistoryPeriod && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}

// 내역 한 줄. 가게 찾기와 정렬은 이 세 값으로 한다
sealed class HistoryRecord {
  int get id;

  String get storeName;

  DateTime get time;
}

// 결제 내역: 충전 1건
final class ChargeRecord implements HistoryRecord {
  const new({
    required this.id,
    required this.storeName,
    required this.amount,
    required this.paidWon,
    required this.chargedAt,
  });

  @override
  final int id;
  @override
  final String storeName;
  final int amount; // 충전 포인트(P)
  final int paidWon; // 결제 금액(원)
  final DateTime chargedAt;

  @override
  DateTime get time => chargedAt;
}

// 가게 이용 내역: 차감 1건
final class UseRecord implements HistoryRecord {
  const new({
    required this.id,
    required this.storeName,
    required this.visitNumber,
    required this.method,
    required this.amount,
    required this.chargeAmount,
    required this.sharedAmount,
    required this.serviceAmount,
    required this.usedAt,
  });

  @override
  final int id;
  @override
  final String storeName;
  final int visitNumber; // 그 가게에서 몇 번째로 쓴 것인지
  final UseMethod? method; // 앱이 모르는 방식이면 null
  final int amount; // 쓴 포인트(P)
  final int chargeAmount; // 그 중 충전포인트(P)
  final int sharedAmount; // 그 중 공유포인트(P)
  final int serviceAmount; // 그 중 서비스포인트(P)
  final DateTime usedAt;

  @override
  DateTime get time => usedAt;
}

// 서비스포인트: 받은 서비스포인트 1건
final class ServiceRecord implements HistoryRecord {
  const new({
    required this.id,
    required this.storeName,
    required this.amount,
    required this.status,
    required this.daysLeft,
    required this.receivedAt,
  });

  @override
  final int id;
  @override
  final String storeName;
  final int amount; // 받은 포인트(P). 남은 포인트가 아니다
  final ServiceStatus status;
  final int? daysLeft; // 기한까지 남은 날. 기한이 없거나 지났으면 null
  final DateTime receivedAt;

  @override
  DateTime get time => receivedAt;
}

// 차감 방식. 서버 PointUseMethod와 동일
enum UseMethod {
  customer, // 고객 차감
  store; // 가게 차감

  static UseMethod? fromName(String name) => values.asNameMap()[name];
}

// 서비스포인트 묶음을 지금 쓸 수 있는지. 서버 PointLotStatus
enum ServiceStatus { usable, usedUp, expired }

// 한 탭의 잔액과 기록
class HistoryPage<T extends HistoryRecord> {
  const new({required this.balance, required this.items});

  final int balance; // 그 탭의 쓸 수 있는 포인트(P)
  final List<T> items; // 최신 순
}
