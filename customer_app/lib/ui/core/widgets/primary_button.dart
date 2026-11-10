import 'package:flutter/material.dart';

import '../tokens.dart';

// 하단 주요 버튼: 높이 56, 빨강, 17 Bold, 빨강은 한 화면에 한 곳이라 화면마다 하나만 쓴다.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;

  // 서버 응답을 기다리는 동안 글자 대신 도는 표시를 보여주고, 다시 누를 수 없게 함.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(AppSize.button),
        backgroundColor: AppColors.buttonRed,
        foregroundColor: AppColors.surface,
        // 누를 수 없는 상태: 회색 바탕, 회색 글자.
        disabledBackgroundColor: AppColors.bgField,
        disabledForegroundColor: AppColors.iconMuted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      // 글자 스타일은 textStyle 대신 Text에 넣는다.(textStyle은 Pretendard 정을 덮어쓴다)
      child: loading
          ? SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.iconMuted,
              ),
            )
          : Text(label, style: AppText.cardTitle),
    );
  }
}
