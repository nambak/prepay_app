import '../../../data/repositories/point_repository.dart';
import '../../../domain/models/point.dart';
import '../../../domain/models/point_history.dart';
import '../../core/load_view_model.dart';

// 포인트 내역 한 탭. 탭을 바꾸면 경로가 바뀌고 view model도 새로 만든다
class PointHistoryViewModel extends LoadViewModel<HistoryPage<HistoryRecord>> {
  new({
    required this._pointRepository,
    required this.tab,
    required this.period,
  });

  final PointRepository _pointRepository;
  final HistoryTab tab;
  final HistoryPeriod period;

  // 위쪽 탭에서 고른 포인트 종류. 결제 내역과 가게 이용 내역은 충전포인트 탭 안에 있다
  PointType get pointType => switch (tab) {
    HistoryTab.charges || HistoryTab.uses => PointType.charge,
    HistoryTab.shared => PointType.shared,
    HistoryTab.service => PointType.service,
  };

  @override
  Future<HistoryPage<HistoryRecord>> fetch() => switch (tab) {
    HistoryTab.charges => _pointRepository.getChargeHistory(period),
    HistoryTab.uses => _pointRepository.getUseHistory(period),
    HistoryTab.service => _pointRepository.getServiceHistory(period),
    // 공유 기능이 없어서 서버를 부르지 않음
    HistoryTab.shared => Future.value(HistoryPage(balance: 0, items: [])),
  };
}
