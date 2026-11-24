import 'package:material_ui/material_ui.dart';

import '../../core/tokens.dart';

// 내역 카드 오른쪽 위의 상태 배지: '결제 완료', '고객 차감'
class RecordBadge extends StatelessWidget {
  const new(
    this.text, {
    super.key,
    required this.background,
    required this.color,
  });

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
