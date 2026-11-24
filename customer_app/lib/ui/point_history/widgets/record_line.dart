import 'package:material_ui/material_ui.dart';

import '../../core/format.dart';
import '../../core/tokens.dart';

// 내역 카드 안의 한 줄. 이름은 왼쪽 회색, 값은 오른쪽
class RecordLine extends StatelessWidget {
  const new(this.label, this.value, {super.key, required this.style});

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
