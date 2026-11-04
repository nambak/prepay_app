import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prepay_app/ui/my/view_models/withdraw_view_model.dart';
import 'package:prepay_app/ui/my/widgets/remaining_points_card.dart';
import 'package:prepay_app/ui/my/widgets/withdraw_bottom_bar.dart';
import 'package:prepay_app/ui/my/widgets/withdraw_notice.dart';

import '../../core/icons.dart';
import '../../core/tokens.dart';

// 회원 탈퇴
class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key, required this.viewModel});

  final WithdrawViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          tooltip: '뒤로 가기',
          icon: const SvgIcon(
            AppIcons.back,
            color: AppColors.textPrimary,
            strokeWidth: 2,
          ),
        ),
        title: const Text('회원 탈퇴', style: AppText.cardTitle),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.gutter),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      child: Text(
                        '탈퇴하면 남은 포인트가\n모두 사라져요',
                        style: AppText.title.copyWith(height: 1.4),
                      ),
                    ),
                    RemainingPointsCard(
                      wallet: viewModel.wallet,
                      failed: viewModel.failed,
                      onRetry: viewModel.load,
                    ),
                    const SizedBox(height: 16),
                    const WithdrawNotice(),
                  ],
                ),
              ),
              WithdrawBottomBar(
                agreed: viewModel.agreed,
                onAgreeChanged: viewModel.agree,
                error: viewModel.error,
                submitting: viewModel.submitting,
                onWithdraw: viewModel.canWithdraw ? viewModel.withdraw : null,
              )
            ],
          )
        )
      )
    );
  }
}
