import 'package:flutter/material.dart';

import '../tokens.dart';

// 하단 보조 버튼
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(AppSize.button),
        backgroundColor: AppColors.bgField,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      child: Text(
        label,
        style: AppText.cardTitle.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
