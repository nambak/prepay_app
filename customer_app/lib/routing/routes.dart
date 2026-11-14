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
}
