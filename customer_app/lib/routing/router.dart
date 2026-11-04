import 'package:go_router/go_router.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/account/view_models/login_view_model.dart';
import 'package:prepay_app/ui/account/widgets/login_screen.dart';
import 'package:prepay_app/ui/core/widgets/app_tab_bar.dart';
import 'package:prepay_app/ui/core/widgets/coming_soon_screen.dart';
import 'package:prepay_app/ui/my/view_models/withdraw_view_model.dart';
import 'package:prepay_app/ui/my/widgets/my_screen.dart';
import 'package:prepay_app/ui/my/widgets/settings_screen.dart';

import '../data/repositories/point_repository.dart';
import '../ui/my/widgets/withdraw_screen.dart';
import '../ui/wallet_pay/view_models/wallet_view_model.dart';
import '../ui/wallet_pay/widgets/wallet_screen.dart';
import 'routes.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);

// 모든 저장소가 같은 ApiClient를 써야 로그인 토큰이 함께 붙는다.
final _apiClient = ApiClient(baseUrl: _apiBaseUrl);
final authRepository = AuthRepository(apiClient: _apiClient);
final _pointRepository = PointRepository(apiClient: _apiClient);

final router = GoRouter(
  initialLocation: Routes.wallet,

  // 로그인 상태가 바뀌면 redirect를 다시 확인.
  refreshListenable: authRepository,
  redirect: (context, state) {
    final atLogin = state.matchedLocation == Routes.login;
    if (!authRepository.isLoggedIn) return atLogin ? null : Routes.login;
    if (atLogin) return Routes.wallet;
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewModel(authRepository: authRepository),
      ),
    ),
    GoRoute(
      path: Routes.wallet,
      builder: (context, state) => WalletScreen(
        viewModel: WalletViewModel(pointRepository: _pointRepository)..load(),
      ),
    ),
    GoRoute(path: Routes.my, builder: (context, state) => const MyScreen()),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) =>
          SettingsScreen(onLogout: authRepository.logout),
    ),
    GoRoute(
      path: Routes.withdraw,
      builder: (context, state) => WithdrawScreen(
        viewModel: WithdrawViewModel(
          pointRepository: _pointRepository,
          authRepository: authRepository,
        )..load(),
      )
    ),
    // 아직 화면이 없는 탭. 화면을 만들면 목록에서 빼고 GoRoute를 따로 둔다.
    for (final tab in [AppTab.home, AppTab.shop, AppTab.like])
      GoRoute(
        path: tab.path,
        builder: (context, state) => ComingSoonScreen(tab: tab),
      ),
  ],
);
