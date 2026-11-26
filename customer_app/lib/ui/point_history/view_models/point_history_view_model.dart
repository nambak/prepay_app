import '../../../data/repositories/point_repository.dart';
import '../../../domain/models/point.dart';
import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/load_view_model.dart';

// 포인트 내역 한 탭. 탭을 바꾸면 경로가 바뀌고 view model도 새로 만든다
class PointHistoryViewModel extends LoadViewModel<HistoryPage<HistoryRecord>> {
  new({
    required this._pointRepository,
    required this.tab,
    required this._period,
    required this.thisMonth,
  });

  final PointRepository _pointRepository;
  final HistoryTab tab;

  // 기간 시트에서 고를 수 있는 마지막 달. 한국 날짜로 이번 달
  final HistoryPeriod thisMonth;

  // 기간은 이 화면이 들고 있다. 탭을 바꿀 때 경로 쿼리로 넘긴다
  HistoryPeriod _period;

  HistoryPeriod get period => _period;

  // 가게 찾기에 입력한 글자. 받아 온 목록 안에서만 거른다
  String _query = '';

  String get query => _query;

  bool _newestFirst = true;

  bool get newestFirst => _newestFirst;

  // 위쪽 탭에서 고른 포인트 종류. 결제 내역과 가게 이용 내역은 충전포인트 탭 안에 있다
  PointType get pointType => switch (tab) {
    HistoryTab.charges || HistoryTab.uses => PointType.charge,
    HistoryTab.shared => PointType.shared,
    HistoryTab.service => PointType.service,
  };

  // 화면에 보일 기록. 가게 이름에 찾는 글자가 들어간 것만, 고른 순서로
  // 서버가 최신 순으로 주므로 오래된 순은 뒤집기만 한다
  List<HistoryRecord> get records {
    final found = [
      for (final record in data?.items ?? <HistoryRecord>[])
        if (record.storeName.contains(_query.trim())) record,
    ];
    return _newestFirst ? found : found.reversed.toList();
  }

  // 화면에 그릴 묶음. 가게 이용 내역만 한국 날짜로 묶어 머리글을 단다
  // 받은 순서를 지키고, 기간이 한 해 안이라 '11월 3일 (화)'만으로 날이 겹치지 않는다
  List<(String?, List<HistoryRecord>)> get sections {
    if (tab != HistoryTab.uses) return [(null, records)];

    final days = <String, List<HistoryRecord>>{};
    for (final record in records) {
      days.putIfAbsent(formatDayHeader(record.time), () => []).add(record);
    }
    return [for (final MapEntry(:key, :value) in days.entries) (key, value)];
  }

  // 그 기간으로 다시 불러온다. 그동안 이전 기간의 목록은 감춘다
  // 목록을 감추면 가게 찾기 칸도 닫히므로 찾던 글자도 지운다
  Future<void> changePeriod(HistoryPeriod period) async {
    if (period == _period) return;
    _period = period;
    _query = '';
    await load(clear: true);
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  void sortNewestFirst(bool value) {
    _newestFirst = value;
    notifyListeners();
  }

  @override
  Future<HistoryPage<HistoryRecord>> fetch() => switch (tab) {
    HistoryTab.charges => _pointRepository.getChargeHistory(_period),
    HistoryTab.uses => _pointRepository.getUseHistory(_period),
    HistoryTab.service => _pointRepository.getServiceHistory(_period),
    // 공유 기능이 없어서 서버를 부르지 않음
    HistoryTab.shared => Future.value(HistoryPage(balance: 0, items: [])),
  };
}
