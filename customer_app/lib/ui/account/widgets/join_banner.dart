import 'package:flutter/material.dart';

import '../../core/tokens.dart';

// 로그인 화면 아래 회원가입 안내
class JoinBanner extends StatelessWidget {
  const JoinBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
      padding: EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(AppRadius.cardSm),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  '처음이세요?',
                  style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '회원가입하고 지금 방문한 가게에서 바로 할인받아 보세요',
                  style: AppText.secondary.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {}, // TODO: 회원가입
            style: FilledButton.styleFrom(
              minimumSize: Size(0, AppSize.touchTarget),
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '회원가입',
              style: AppText.label.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
