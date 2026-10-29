import 'package:go_router/go_router.dart';

import '../data/repositories/cash_repository.dart';
import '../ui/wallet_pay/view_models/wallet_view_model.dart';
import '../ui/wallet_pay/widgets/wallet_screen.dart';
import 'routes.dart';

final _cashRepository = CashRepository();

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
