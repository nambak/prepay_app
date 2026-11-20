import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../../routing/routes.dart';
import '../../core/tokens.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/load_error.dart';
import '../view_models/point_history_view_model.dart';
import 'charge_record_card.dart';
import 'history_balance_card.dart';
import 'history_tabs.dart';

class PointHistoryScreen extends StatelessWidget {
  const new({super.key, required this.viewModel});

  final PointHistoryViewModel viewModel;

  // 탭을 바꾸면 경로를 바꿔치기한다. 여러 번 바꿔도 뒤로 한 번이면 들어온 곳이다.
  void _select(BuildContext context, HistoryTab tab) =>
      context.replace(Routes.history(tab, viewModel.period));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text('포인트 내역', style: AppText.cardTitle),
      ),
      body: Column(
        children: [
          HistoryTabs(
            viewModel.pointType,
            onSelect: (tab) => _select(context, tab),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                final page = viewModel.data;
                if (page == null) {
                  return viewModel.failed
                      ? LoadError('포인트 내역을 불러오지 못했어요.', onRetry: viewModel.load)
                      : Center(child: CircularProgressIndicator());
                }
                final (title, message) = _emptyText(viewModel.tab);

                return ListView(
                  padding: EdgeInsets.only(top: 12, bottom: 24),
                  children: [
                    HistoryBalanceCard(
                      viewModel.pointType,
                      viewModel.tab,
                      page.balance,
                      onSelect: (tab) => _select(context, tab),
                    ),
                    SizedBox(height: 12),
                    if (page.items.isEmpty)
                      EmptyState(title, message)
                    else
                      Column(
                        spacing: 8,
                        children: [
                          for (final record in page.items)
                            switch (record) {
                              ChargeRecord() => ChargeRecordCard(record),
                              // 나중에 카드를 넣는다
                              UseRecord() || ServiceRecord() => SizedBox(),
                            },
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 기록이 없을 때의 제목과 설명
(String, String) _emptyText(HistoryTab tab) => switch (tab) {
  HistoryTab.charges => ('이 기간에 결제한 내역이 없어요', '기간을 바꿔 보세요'),
  HistoryTab.uses => ('이 기간에 쓴 내역이 없어요', '기간을 바꿔 보세요'),
  HistoryTab.service => ('이 기간에 받은 서비스포인트가 없어요', '기간을 바꿔 보세요'),
  HistoryTab.shared => ('아직 공유포인트가 없어요', '공유 기능을 준비하고 있어요'),
};
