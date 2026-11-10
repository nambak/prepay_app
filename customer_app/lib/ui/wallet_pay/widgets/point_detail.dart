// 가게 카드 아래 '포인트 상세' 접고 펴기

import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/point_dot.dart';

class PointDetail extends StatelessWidget {
  const PointDetail(
    this.store, {
    super.key,
    required this.expanded,
    required this.onToggle,
  });

  final StoreWallet store;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderInner)),
      ),
      child: Column(
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              onTap: onToggle,
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '포인트 상세',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SvgIcon(
                      expanded ? AppIcons.chevronUp : AppIcons.chevronDown,
                      size: 20,
                      color: AppColors.textMuted,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded)
            Column(
              spacing: 12,
              children: [
                for (final item in store.items)
                  Row(
                    spacing: 8,
                    children: [
                      PointDot(item.type),
                      Expanded(
                        child: Text(
                          item.type.label,
                          style: AppText.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (item.daysLeft case final daysLeft?)
                        _Badge('D-$daysLeft'),
                      SizedBox(
                        width: 96,
                        child: Text(
                          formatNumber(item.amount),
                          textAlign: TextAlign.right,
                          style: AppText.label.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFeatures: tabularFigures,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        text,
        style: AppText.badge.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
