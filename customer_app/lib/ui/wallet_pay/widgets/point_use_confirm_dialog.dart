import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../view_models/point_use_view_model.dart';

// 차감 확인. 차감이 끝나면 true, 취소하면 false를 불러온다
// 차감하는 동안은 뒤로 가기·바깥 누르기·취소로 닫히지 않는다.
class PointUseConfirmDialog extends StatelessWidget {
  const PointUseConfirmDialog(this.viewModel, {super.key});

  final PointUseViewModel viewModel;

  Future<void> _use(BuildContext context) async {
    await viewModel.submit();

    if (viewModel.receipt != null && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = '${formatNumber(viewModel.amount)}P';

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => PopScope(
        canPop: !viewModel.submitting,
        child: Dialog(
          backgroundColor: AppColors.surface,
          insetPadding: EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.cardLg),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${viewModel.store.name}에서\n$amount를 쓸까요?',
                  style: AppText.section.copyWith(
                    height: 1.45,
                    fontFeatures: tabularFigures,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.bgField,
                    borderRadius: BorderRadius.circular(AppRadius.cardSm),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      _Row('쓸 포인트', amount, AppText.bodyBold),
                      _Row(
                        '쓰고 남는 포인트',
                        '${formatNumber(viewModel.balanceAfter)}P',
                        AppText.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '가게 사장님과 금액을 함께 확인해 주세요.',
                  style: AppText.label.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
                if (viewModel.error case final error?) ...[
                  SizedBox(height: 8),
                  Text(
                    error,
                    style: AppText.secondary.copyWith(color: AppColors.danger),
                  ),
                ],
                SizedBox(height: 24),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: '취소',
                        // 차감하는 동안은 PopScope가 막는다
                        onPressed: () => Navigator.maybePop(context, false),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        label: '쓰기',
                        loading: viewModel.submitting,
                        onPressed: () => _use(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, this.valueStyle);

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.label.copyWith(color: AppColors.textMuted),
          ),
        ),
        Text(value, style: valueStyle.copyWith(fontFeatures: tabularFigures)),
      ],
    );
  }
}
