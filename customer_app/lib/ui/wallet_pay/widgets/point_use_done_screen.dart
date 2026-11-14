import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/point_use.dart';
import '../../../routing/routes.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/point_dot.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/receipt_row.dart';
import '../../core/widgets/secondary_button.dart';

// 사용 완료
// 리뷰 쓰기와 이용 내역 보기는 그 화면을 만들 때 단다
class PointUseDoneScreen extends StatelessWidget {
  const PointUseDoneScreen(this.receipt, {super.key});

  final PointUseReceipt receipt;

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
                    '$amount를 썼어요',
                    textAlign: TextAlign.center,
                    style: AppText.title.copyWith(fontFeatures: tabularFigures),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${receipt.storeName} · ${receipt.visitCount}번째 이용',
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
                        ReceiptRow('사용 일시', formatDateTime(receipt.usedAt)),
                        Column(
                          spacing: 10,
                          children: [
                            ReceiptRow('쓴 포인트', amount, bold: true),
                            // 0P인 종류는 숨긴다
                            if (receipt.serviceAmount > 0)
                              _PartRow(
                                PointType.service,
                                receipt.serviceAmount,
                              ),
                            if (receipt.chargeAmount > 0)
                              _PartRow(PointType.charge, receipt.chargeAmount),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.border),
                            ),
                          ),
                          child: ReceiptRow(
                            '남은 포인트',
                            '${formatNumber(receipt.balance)}P',
                            bold: true,
                          ),
                        ),
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
                      label: '확인',
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

// 쓴 포인트 중 한 종류. 점과 이름, 포인트
class _PartRow extends StatelessWidget {
  const _PartRow(this.type, this.amount);

  final PointType type;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        PointDot(type),
        Expanded(
          child: Text(
            type.label,
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          '${formatNumber(amount)}P',
          style: AppText.label.copyWith(fontFeatures: tabularFigures),
        ),
      ],
    );
  }
}
