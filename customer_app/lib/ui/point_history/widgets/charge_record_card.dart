import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import 'record_badge.dart';
import 'record_line.dart';

// 결제 내역: 충전 1건
class ChargeRecordCard extends StatelessWidget {
  const new(this.record, {super.key});

  final ChargeRecord record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.card,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Expanded(child: Text(record.storeName, style: AppText.inputBold)),
              RecordBadge(
                '결제 완료',
                background: AppColors.successBg,
                color: AppColors.successText,
              ),
            ],
          ),
          Column(
            spacing: 6,
            children: [
              RecordLine(
                '충전 포인트',
                '${formatNumber(record.amount)}P',
                style: AppText.body,
              ),
              RecordLine(
                '결제 금액',
                '${formatNumber(record.paidWon)}원',
                style: AppText.bodyBold,
              ),
              RecordLine(
                '결제 일시',
                formatDateTime(record.chargedAt),
                style: AppText.label,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
