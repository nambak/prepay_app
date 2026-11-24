import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/point_dot.dart';

// 그 탭의 쓸 수 있는 포인트. 충전포인트 탭은 결제 내역과 가게 이용 내역을 고르는 칸이 함께 있다
class HistoryBalanceCard extends StatelessWidget {
  const new(
    this.type,
    this.tab,
    this.balance, {
    super.key,
    required this.onSelect,
  });

  final PointType type;
  final HistoryTab tab;
  final int balance;
  final ValueChanged<HistoryTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '쓸 수 있는 ${type.label}',
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 6,
            children: [
              Text(
                formatNumber(balance),
                style: AppText.balance.copyWith(fontFeatures: tabularFigures),
              ),
              Text('P', style: AppText.section),
            ],
          ),
          if (type == PointType.charge) ...[
            SizedBox(height: 16),
            _ChargeSwitch(tab, onSelect: onSelect),
          ],
        ],
      ),
    );
  }
}

// 결제 내역 | 가게 이용 내역. 회색 바탕 안에서 고른 칸만 흰색으로
// 눌리는 높이는 바탕 높이(48)와 같고, 흰 칸은 그 안에 40으로 그린다
class _ChargeSwitch extends StatelessWidget {
  const new(this.tab, {required this.onSelect});

  final HistoryTab tab;
  final ValueChanged<HistoryTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final (item, label) in [
            (HistoryTab.charges, '결제 내역'),
            (HistoryTab.uses, '가게 이용 내역'),
          ])
            Expanded(
              child: item == tab
                  ? Semantics(
                      container: true,
                      selected: true,
                      child: _SwitchCell(label, selected: true),
                    )
                  : Semantics(
                      container: true,
                      button: true,
                      child: InkWell(
                        onTap: () => onSelect(item),
                        child: _SwitchCell(label, selected: false),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class _SwitchCell extends StatelessWidget {
  const new(this.label, {required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: selected
            ? BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(9),
              )
            : null,
        child: Text(
          label,
          style: selected
              ? AppText.bodyBold
              : AppText.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
