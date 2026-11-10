import 'package:flutter/material.dart';

import '../../core/tokens.dart';
import '../view_models/withdraw_view_model.dart';
import 'remaining_points_card.dart';
import 'withdraw_bottom_bar.dart';
import 'withdraw_notice.dart';

// 회원 탈퇴
class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key, required this.viewModel});

  final WithdrawViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      // 탈퇴 요청 중에는 화면을 닫지 않는다. 닫아도 요청은 계속 가서, 취소한 줄 알았는데 탈퇴될 수 있다.
      // 뒤로 가기, 취소 버튼은 PopScope를 따르는 maybePop을 쓴다(context.pop은 따르지 않는다).
      builder: (context, _) => PopScope(
        canPop: !viewModel.submitting,
        child: Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text('회원 탈퇴', style: AppText.cardTitle),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 24),
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
                      SizedBox(height: 16),
                      WithdrawNotice(),
                    ],
                  ),
                ),
                WithdrawBottomBar(
                  agreed: viewModel.agreed,
                  onAgreeChanged: viewModel.agree,
                  error: viewModel.error,
                  submitting: viewModel.submitting,
                  onWithdraw: viewModel.canWithdraw ? viewModel.withdraw : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
