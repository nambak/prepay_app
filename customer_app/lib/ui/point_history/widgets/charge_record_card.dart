import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';

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
              _Badge(
                '결제 완료',
                background: AppColors.successBg,
                color: AppColors.successText,
              ),
            ],
          ),
          Column(
            spacing: 6,
            children: [
              _Line(
                '충전 포인트',
                '${formatNumber(record.amount)}P',
                style: AppText.body,
              ),
              _Line(
                '결제 금액',
                '${formatNumber(record.paidWon)}원',
                style: AppText.bodyBold,
              ),
              _Line(
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

// 카드 오른쪽 위의 상태 배지
class _Badge extends StatelessWidget {
  const new(this.text, {required this.background, required this.color});

  final String text;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(text, style: AppText.badge.copyWith(color: color)),
    );
  }
}

// 카드 안의 한 줄. 이름은 왼쪽 회색, 값은 오른쪽
class _Line extends StatelessWidget {
  const new(this.label, this.value, {required this.style});

  final String label;
  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: 12,
      children: [
        Text(label, style: AppText.label.copyWith(color: AppColors.textMuted)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: style.copyWith(fontFeatures: tabularFigures),
          ),
        ),
      ],
    );
  }
}
