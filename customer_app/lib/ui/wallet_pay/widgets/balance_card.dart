// 전체 포인트 합계, 종류별 비율 막대, 종류별 금액
import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/point_dot.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard(this.wallet, {super.key});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final parts = [
      (PointType.charge, wallet.charge),
      (PointType.shared, wallet.shared),
      (PointType.service, wallet.service),
    ];

    return AppCard(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '쓸 수 있는 포인트',
                style: AppText.label.copyWith(color: AppColors.textSecondary),
              ),
              IconButton(
                onPressed: () {}, // TODO: 포인트 종류 설명 시트
                tooltip: '포인트 종류 설명 보기',
                icon: SvgIcon(
                  AppIcons.info,
                  size: 18,
                  color: AppColors.iconMuted,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 6,
            children: [
              Text(
                formatNumber(wallet.total),
                style: AppText.balance.copyWith(fontFeatures: tabularFigures),
              ),
              Text('P', style: AppText.section),
            ],
          ),
          SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '즐겨찾는 가게에서 지금까지 '),
                TextSpan(
                  text: '${formatNumber(wallet.savedWon)}원',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(text: ' 아꼈어요'),
              ],
            ),
            style: AppText.secondary.copyWith(color: AppColors.textSecondary),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8),
            child: SizedBox(
              height: 8,
              child: Row(
                spacing: 3,
                children: [
                  for (final (type, amount) in parts)
                    if (amount > 0)
                      Expanded(
                        flex: amount,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: type.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          for (final (i, (type, amount)) in parts.indexed)
            InkWell(
              onTap: () {}, // TODO: 포인트 내역
              child: Container(
                height: 48,
                decoration: i == 0
                    ? null
                    : BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.borderInner),
                        ),
                      ),
                child: Row(
                  spacing: 10,
                  children: [
                    PointDot(type),
                    Expanded(child: Text(type.label)),
                    Text(
                      formatNumber(amount),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFeatures: tabularFigures,
                      ),
                    ),
                    SvgIcon(
                      AppIcons.chevronRight,
                      size: 18,
                      color: AppColors.iconMuted,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
