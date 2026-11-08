import 'package:flutter/material.dart';

import '../../core/widgets/app_tab_bar.dart';
import '../../core/widgets/load_error.dart';
import '../view_models/wallet_view_model.dart';
import 'balance_card.dart';
import 'store_card.dart';
import 'store_tabs.dart';
import 'wallet_header.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.viewModel});

  final WalletViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppTabBar(current: AppTab.wallet),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final wallet = viewModel.wallet;
            if (wallet == null) {
              return viewModel.failed
                  ? LoadError('포인트를 불러오지 못했어요.', onRetry: viewModel.load)
                  : const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const WalletHeader(),
                const SizedBox(height: 8),
                BalanceCard(wallet),
                const SizedBox(height: 24),
                StoreTabs(count: wallet.stores.length),
                // TODO: 가게 검색창
                for (final store in wallet.stores) ...[
                  const SizedBox(height: 12),
                  StoreCard(
                    store,
                    expanded: viewModel.expandedStoreId == store.id,
                    onToggleDetail: () => viewModel.toggleDetail(store.id),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
