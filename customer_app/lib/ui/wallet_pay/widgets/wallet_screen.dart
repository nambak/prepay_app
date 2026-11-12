import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/point_use.dart';
import '../../core/widgets/app_tab_bar.dart';
import '../../core/widgets/load_error.dart';
import '../../core/widgets/view_model_scope.dart';
import '../view_models/point_use_view_model.dart';
import '../view_models/wallet_view_model.dart';
import 'balance_card.dart';
import 'point_use_sheet.dart';
import 'store_card.dart';
import 'store_tabs.dart';
import 'wallet_header.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({
    super.key,
    required this.viewModel,
    required this.createPointUse,
  });

  final WalletViewModel viewModel;
  final PointUseViewModel Function(StoreWallet store) createPointUse;

  // 차감하기. 시트가 닫히면 끝났는지 상관없이 포인트를 다시 불러온다
  // 썼는지 확인하지 못한 실패 뒤에도 남은 포인트가 맞게 보이게 하려는 것이다
  Future<void> _openPointUse(BuildContext context, StoreWallet store) async {
    await showModalBottomSheet<PointUseReceipt>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ViewModelScope(
        create: () => createPointUse(store),
        builder: PointUseSheet.new,
      ),
    );
    viewModel.load();
    // TODO: 사용 완료 화면을 만들면 영수증을 받아서 연결
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppTabBar(current: AppTab.wallet),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final wallet = viewModel.wallet;
            if (wallet == null) {
              return viewModel.failed
                  ? LoadError('포인트를 불러오지 못했어요.', onRetry: viewModel.load)
                  : Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: EdgeInsets.only(bottom: 24),
              children: [
                WalletHeader(),
                SizedBox(height: 8),
                BalanceCard(wallet),
                SizedBox(height: 24),
                StoreTabs(count: wallet.stores.length),
                // TODO: 가게 검색창
                for (final store in wallet.stores) ...[
                  SizedBox(height: 12),
                  StoreCard(
                    store,
                    expanded: viewModel.expandedStoreId == store.id,
                    onToggleDetail: () => viewModel.toggleDetail(store.id),
                    onUse: () => _openPointUse(context, store),
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
