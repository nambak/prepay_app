import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';

class ChargeBottomBar extends StatelessWidget {
  const ChargeBottomBar({
    super.key,
    required this.priceWon,
    required this.error,
    required this.submitting,
    required this.onPay,
  });

  final int priceWon;
  final String? error;
  final bool submitting;

  // 이용 안내를 확인하기 전이면 null이라 누를 수 없다.
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    // 흰 바탕이 홈 인디케이터 자리까지 이어지게 SafeArea를 안에 둔다.
    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.gutter,
            12,
            AppSpace.gutter,
            12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              if (error case final error?)
                Text(
                  error,
                  style: AppText.secondary.copyWith(color: AppColors.danger),
                ),
              PrimaryButton(
                label: '${formatNumber(priceWon)}원 결제하기',
                onPressed: onPay,
                loading: submitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
