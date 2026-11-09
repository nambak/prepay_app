import 'package:flutter/material.dart';

import '../tokens.dart';

// 라벨 + 입력창. 입력창 모양은 theme.dart의 inputDecorationTheme이 정한다.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final TextField child;

  @override
  Widget build(BuildContext context) {
    // 화면 읽기 프로그램이 입력창에 닿으면 라벨도 함께 읽어준다.
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          Text(
            label,
            style: AppText.label.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
