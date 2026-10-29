import 'package:go_router/go_router.dart';
import 'package:prepay_app/data/services/api_client.dart';

import '../data/repositories/cash_repository.dart';
import '../ui/wallet_pay/view_models/wallet_view_model.dart';
import '../ui/wallet_pay/widgets/wallet_screen.dart';
import 'routes.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);

final _cashRepository = CashRepository(
  apiClient: ApiClient(baseUrl: _apiBaseUrl),
);

final router = GoRouter(
  initialLocation: Routes.wallet,
  routes: [
    GoRoute(
      path: Routes.wallet,
      builder: (context, state) => WalletScreen(
        viewModel: WalletViewModel(cashRepository: _cashRepository)..load(),
      ),
    ),
  ],
);
