import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/point_dot.dart';

class RemainingPointsCard extends StatelessWidget {
  const RemainingPointsCard({
    super.key,
    required this.wallet,
    required this.failed,
    required this.onRetry,
  });

  final Wallet? wallet;
  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final wallet = this.wallet;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: wallet == null
          ? _Loading(failed: failed, onRetry: onRetry)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '남은 포인트',
                  style: AppText.label.copyWith(color: AppColors.textSecondary),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  spacing: 6,
                  children: [
                    Text(
                      formatNumber(wallet.total),
                      style: AppText.balance.copyWith(
                        fontFeatures: tabularFigures,
                      ),
                    ),
                    const Text('P', style: AppText.section),
                  ],
                ),
                const SizedBox(height: 8),
                _PointRow(PointType.charge, wallet.charge),
                _PointRow(PointType.shared, wallet.shared, divided: true),
                _PointRow(PointType.service, wallet.service, divided: true),
              ],
            ),
    );
  }
}

// 포인트 종류 한 줄. divided면 위에 구분선을 긋는다.
class _PointRow extends StatelessWidget {
  const _PointRow(this.type, this.amount, {this.divided = false});

  final PointType type;
  final int amount;
  final bool divided;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.touchTarget,
      decoration: divided
          ? const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            )
          : null,
      child: Row(
        spacing: 10,
        children: [
          PointDot(type),
          Expanded(child: Text(type.label, style: AppText.body)),
          Text(
            formatNumber(amount),
            style: AppText.body.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

// 불러오는 중이면 로딩 표시, 실패하면 다시 불러오기 버튼
class _Loading extends StatelessWidget {
  const _Loading({required this.failed, required this.onRetry});

  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: failed
            ? Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Text(
                    '포인트를 불러오지 못했어요.',
                    style: AppText.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(onPressed: onRetry, child: const Text('다시 불러오기')),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
