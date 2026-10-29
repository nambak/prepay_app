import 'package:flutter/material.dart';
import 'package:prepay_app/ui/core/widgets/app_tab_bar.dart';
import 'package:prepay_app/ui/wallet_pay/view_models/wallet_view_model.dart';
import 'package:prepay_app/ui/wallet_pay/widgets/wallet_header.dart';

import 'balance_card.dart';
import 'store_card.dart';
import 'store_tabs.dart';

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
              return const Center(child: CircularProgressIndicator());
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
                  )
                ]
              ],
            );
          }
        )
      )
    );
  }
}
