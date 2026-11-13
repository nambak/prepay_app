// 금액 입력. 차감을 누르면 확인을 띄우고, 차감이 끝나면 영수증을 돌려주며 닫힌다
// 메뉴를 골라서 금액 계산하기는 메뉴 만들 때 단다
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/labeled_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/store_thumb.dart';
import '../view_models/point_use_view_model.dart';
import 'point_use_confirm_dialog.dart';

class PointUseSheet extends StatelessWidget {
  const PointUseSheet(this.viewModel, {super.key});

  final PointUseViewModel viewModel;

  Future<void> _confirm(BuildContext context) async {
    final used = await showDialog<bool>(
      context: context,
      builder: (_) => PointUseConfirmDialog(viewModel),
    );

    if (used == true && context.mounted) {
      Navigator.pop(context, viewModel.receipt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = viewModel.store;

    return SafeArea(
      top: false,
      child: Padding(
        // 키보드가 올라오면 시트도 그만큼 올라간다
        padding: EdgeInsets.fromLTRB(
          AppSpace.gutter,
          0,
          AppSpace.gutter,
          12 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              Row(
                spacing: 12,
                children: [
                  StoreThumb(store.kind, size: 44),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          store.name,
                          style: AppText.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${viewModel.visitNumber}번째 이용',
                          style: AppText.secondary.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              LabeledField(
                label: '쓸 금액',
                // P는 입력칸 밖에 둔다. 입력칸의 suffixText는 autofocus와 함께
                // LabeledField(MergeSemantics) 안에서 semantics 오류를 낸다
                child: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.textPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    spacing: 6,
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          // 입력칸에는 쉼표를 찍지 않는다.
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: viewModel.setAmount,
                          style: AppText.balance.copyWith(
                            fontFeatures: tabularFigures,
                          ),
                          decoration: InputDecoration.collapsed(hintText: null),
                        ),
                      ),
                      Text('P', style: AppText.section),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '쓸 수 있는 포인트',
                      style: AppText.label.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                  Text(
                    '${formatNumber(store.total)}P',
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: tabularFigures,
                    ),
                  ),
                ],
              ),
              ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => PrimaryButton(
                  label: switch (viewModel.amount) {
                    0 => '쓸 금액을 넣어 주세요',
                    _ when viewModel.overBalance => '쓸 수 있는 포인트보다 많아요',
                    final amount => '${formatNumber(amount)}P 쓰기',
                  },
                  onPressed: viewModel.canUse ? () => _confirm(context) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
