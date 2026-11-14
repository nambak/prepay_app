import 'package:material_ui/material_ui.dart';

import '../format.dart';
import '../tokens.dart';

// 완료 화면 영수증의 한 줄. 이름은 왼쪽, 값은 오른쪽
class ReceiptRow extends StatelessWidget {
  const ReceiptRow(this.label, this.value, {super.key, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Text(label, style: AppText.body.copyWith(color: AppColors.textMuted)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: (bold ? AppText.bodyBold : AppText.bodyMedium).copyWith(
              fontFeatures: tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
