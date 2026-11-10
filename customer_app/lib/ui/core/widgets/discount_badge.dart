import 'package:flutter/material.dart';

import '../tokens.dart';

// 할인 배지: '최대 20%', '5% 할인'
class DiscountBadge extends StatelessWidget {
  const DiscountBadge(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.discountBg,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        text,
        style: AppText.badge.copyWith(color: AppColors.discountText),
      ),
    );
  }
}
