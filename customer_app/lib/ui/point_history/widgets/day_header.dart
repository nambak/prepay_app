import 'package:material_ui/material_ui.dart';

import '../../core/tokens.dart';

// 가게 이용 내역의 날짜 머리글: 11월 3일 (화)
class DayHeader extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter, vertical: 8),
        child: Text(
          text,
          style: AppText.secondaryMedium.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
