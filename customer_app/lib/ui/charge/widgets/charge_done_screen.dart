import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/charge.dart';
import '../../../routing/routes.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';

// 충전 완료
class ChargeDoneScreen extends StatelessWidget {
  const ChargeDoneScreen(this.receipt, {super.key});

  final ChargeReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final amount = '${formatNumber(receipt.amount)}P';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.gutter,
                  72,
                  AppSpace.gutter,
                  24,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        shape: BoxShape.circle,
                      ),
                      child: SvgIcon(
                        AppIcons.check,
                        size: 34,
                        color: AppColors.successText,
                        strokeWidth: 2.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '$amount\n충전이 끝났어요',
                    textAlign: TextAlign.center,
                    style: AppText.title.copyWith(
                      height: 1.4,
                      fontFeatures: tabularFigures,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    receipt.storeName,
                    textAlign: TextAlign.center,
                    style: AppText.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 36),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgField,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      spacing: 14,
                      children: [
                        _ReceiptRow('충전 가게', receipt.storeName),
                        _ReceiptRow('충전 포인트', amount, bold: true),
                        _ReceiptRow(
                          '결제 금액',
                          '${formatNumber(receipt.paidWon)}원',
                        ),
                        _ReceiptRow('충전 일시', formatDateTime(receipt.chargedAt)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.gutter,
                12,
                AppSpace.gutter,
                12,
              ),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: '홈으로',
                      onPressed: () => context.go(Routes.home),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: '즐겨찾는 가게에서 보기',
                      onPressed: () => context.go(Routes.wallet),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Text(label, style: AppText.body.copyWith(color: AppColors.textMuted)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppText.body.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontFeatures: tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
