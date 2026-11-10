import 'package:flutter/material.dart';

import '../tokens.dart';

// 흰 바탕 둥근 카드
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.padding,
    required this.child,
    this.radius = AppRadius.cardLg,
  });

  final EdgeInsets padding;
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpace.cardMargin),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
