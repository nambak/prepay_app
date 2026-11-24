import 'package:material_ui/material_ui.dart';

import '../icons.dart';
import '../tokens.dart';

// 보여 줄 기록이 없을 때: 영수증 아이콘, 제목, 설명
class EmptyState extends StatelessWidget {
  const new(this.title, this.message, {super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter, vertical: 48),
      child: Column(
        spacing: 8,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: SvgIcon(
              AppIcons.receipt,
              size: 28,
              color: AppColors.iconMuted,
              strokeWidth: 1.7,
            ),
          ),
          Text(title, textAlign: TextAlign.center, style: AppText.inputBold),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.secondary.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
