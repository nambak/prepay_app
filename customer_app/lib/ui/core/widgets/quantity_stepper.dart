import 'package:flutter/material.dart';

import '../format.dart';
import '../icons.dart';
import '../tokens.dart';

// 수량 스테퍼: 흰 바탕, -/+ 버튼, 숫자 16/700.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.label,
    required this.quantity,
    required this.max,
    required this.onChanged,
  });

  final String label; // 화면 낭독기가 읽는 이름. 예: '50,000P'
  final int quantity;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.touchTarget,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: AppIcons.minus,
            tooltip: '$label 수량 줄이기',
            onPressed: quantity > 0 ? () => onChanged(quantity - 1) : null,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 28),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppText.input.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: tabularFigures,
              ),
            ),
          ),
          _StepButton(
            icon: AppIcons.plus,
            tooltip: '$label 수량 늘리기',
            onPressed: quantity < max ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final String icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      // 누를 수 없으면 회색
      color: AppColors.textPrimary,
      disabledColor: AppColors.iconMuted,
      constraints: BoxConstraints.tightFor(
        width: AppSize.touchTarget,
        height: AppSize.touchTarget,
      ),
      padding: EdgeInsets.zero,
      icon: SvgIcon(icon, size: 18, strokeWidth: 2),
    );
  }
}
