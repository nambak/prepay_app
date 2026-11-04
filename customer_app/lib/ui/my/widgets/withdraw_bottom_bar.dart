import 'package:flutter/material.dart';

import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';

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
        padding: const EdgeInsets.fromLTRB(
            AppSpace.gutter, 0, AppSpace.gutter, 12),
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
                style: AppText.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (error case final error?)
              Text(error,
                  style: AppText.secondary.copyWith(color: AppColors.danger)),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children: [
                const Expanded(child: _CancelButton()),
                Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: '탈퇴하기',
                      onPressed: onWithdraw,
                      loading: submitting,
                    )
                )
              ],
            )
          ],
        )
    );
  }
}

// 보조 버튼: 회색 바탕, 잉크 글자 500
class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // PopScope를 따르도록 maybePop을 쓴다. 탈퇴 요청 중에는 닫히지 않는다
      onPressed: () => Navigator.maybePop(context),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSize.button),
        backgroundColor: AppColors.bgField,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        )
      ),
      child: Text(
        '취소',
        style: AppText.cardTitle.copyWith(fontWeight: FontWeight.w500),
      )
    );
  }
}
