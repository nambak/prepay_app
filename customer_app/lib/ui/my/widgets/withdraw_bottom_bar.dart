import 'package:flutter/material.dart';

import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';

class WithdrawBottomBar extends StatelessWidget {
  const WithdrawBottomBar({
    super.key,
    required this.agreed,
    required this.onAgreeChanged,
    required this.error,
    required this.submitting,
    required this.onWithdraw,
  });

  final bool agreed;
  final ValueChanged<bool> onAgreeChanged;
  final String? error;
  final bool submitting;

  // 동의하기 전이면 null이라 누를 수 없다.
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpace.gutter, 0, AppSpace.gutter, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: agreed,
            onChanged: (value) => onAgreeChanged(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.textPrimary,
            title: Text(
              '남은 포인트가 사라지는 것을 확인했고, 탈퇴에 동의해요',
              style: AppText.bodyBold,
            ),
          ),
          if (error case final error?)
            Text(
              error,
              style: AppText.secondary.copyWith(color: AppColors.danger),
            ),
          SizedBox(height: 12),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: SecondaryButton(
                  label: '취소',
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: '탈퇴하기',
                  onPressed: onWithdraw,
                  loading: submitting,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
