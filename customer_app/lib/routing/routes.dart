import '../domain/models/point_history.dart';

abstract final class Routes {
  static const login = '/login';
  static const home = '/home';
  static const shop = '/shop';
  static const wallet = '/wallet';
  static const pointUseDone = '/wallet/use-done';
  static const likes = '/likes';
  static const my = '/my';
  static const settings = '/my/settings';
  static const withdraw = '/my/withdraw';

  static String store(int id) => '/shop/$id';

  static String charge(int storeId) => '/shop/$storeId/charge';

  // 포인트 내역. 기간을 빼면 이번 달
  static String history(HistoryTab tab, [HistoryPeriod? period]) => Uri(
    path: '/wallet/history/${tab.name}',
    queryParameters: period?.toQuery(),
  ).toString();
}
