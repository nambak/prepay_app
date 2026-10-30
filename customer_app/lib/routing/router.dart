import 'package:go_router/go_router.dart';
import 'package:prepay_app/data/repositories/auth_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/account/view_models/login_view_model.dart';
import 'package:prepay_app/ui/account/widgets/login_screen.dart';

import '../data/repositories/cash_repository.dart';
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
final _cashRepository = CashRepository(apiClient: _apiClient);

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
        viewModel: LoginViewModel(authRepository: authRepository)
      )
    ),
    GoRoute(
      path: Routes.wallet,
      builder: (context, state) => WalletScreen(
        viewModel: WalletViewModel(cashRepository: _cashRepository)..load(),
      ),
    ),
  ],
);
