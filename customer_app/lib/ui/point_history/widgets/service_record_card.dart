import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import 'record_badge.dart';
import 'record_line.dart';

// 서비스포인트: 받은 서비스포인트 1건
class ServiceRecordCard extends StatelessWidget {
  const new(this.record, {super.key});

  final ServiceRecord record;

  @override
  Widget build(BuildContext context) {
    // 더 쓸 수 없는 까닭. 쓸 수 있으면 null
    final ended = switch (record.status) {
      ServiceStatus.usable => null,
      ServiceStatus.usedUp => '모두 씀',
      ServiceStatus.expired => '기한 지남',
    };

    return AppCard(
      radius: AppRadius.card,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Expanded(child: Text(record.storeName, style: AppText.inputBold)),
              Row(
                spacing: 4,
                children: [
                  // 다 썼어도 기한이 남았으면 '모두 씀'과 함께 보여 준다
                  if (record.daysLeft case final daysLeft?)
                    RecordBadge(
                      'D-$daysLeft',
                      background: AppColors.pointServiceBg,
                      color: AppColors.pointServiceText,
                    ),
                  if (ended != null)
                    RecordBadge(
                      ended,
                      background: AppColors.bgField,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ],
          ),
          RecordLine(
            '받은 포인트',
            formatNumber(record.amount),
            unit: 'P',
            style: AppText.section.copyWith(
              color: ended == null ? null : AppColors.textMuted,
            ),
          ),
          Text(
            '받은 날 ${formatDateTime(record.receivedAt)}',
            style: AppText.secondary.copyWith(
              color: AppColors.textMuted,
              fontFeatures: tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
