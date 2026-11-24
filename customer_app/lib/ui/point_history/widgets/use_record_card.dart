import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/point_dot.dart';
import 'record_badge.dart';
import 'record_line.dart';

// 가게 이용 내역: 차감 1건
class UseRecordCard extends StatelessWidget {
  const new(this.record, {super.key});

  final UseRecord record;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.card,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        spacing: 14,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.storeName, style: AppText.inputBold),
                    Text(
                      '${record.visitNumber}번째 이용',
                      style: AppText.secondary.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // 가게 차감은 QR 차감과 나누기 전이라 그리지 않는다
              if (record.method == UseMethod.customer)
                RecordBadge(
                  '고객 차감',
                  background: AppColors.bgField,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 12,
            children: [
              Text(
                '쓴 포인트',
                style: AppText.label.copyWith(color: AppColors.textMuted),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: formatNumber(record.amount),
                    children: [TextSpan(text: 'P', style: AppText.bodyBold)],
                  ),
                  textAlign: TextAlign.right,
                  style: AppText.section.copyWith(fontFeatures: tabularFigures),
                ),
              ),
            ],
          ),
          // 쓴 포인트가 어느 포인트에서 나갔는지
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.bgField,
              borderRadius: BorderRadius.circular(AppRadius.field),
            ),
            child: Column(
              spacing: 8,
              children: [
                for (final (type, amount) in [
                  (PointType.charge, record.chargeAmount),
                  (PointType.shared, record.sharedAmount),
                  (PointType.service, record.serviceAmount),
                ])
                  Row(
                    spacing: 8,
                    children: [
                      PointDot(type),
                      Expanded(
                        child: Text(
                          type.label,
                          style: AppText.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        formatNumber(amount),
                        style: AppText.label.copyWith(
                          fontFeatures: tabularFigures,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          RecordLine(
            '이용 일시',
            formatDateTime(record.usedAt),
            style: AppText.label,
          ),
        ],
      ),
    );
  }
}
