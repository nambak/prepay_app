import 'package:flutter/material.dart';

import '../../../domain/models/charge.dart';
import '../../../domain/models/store.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/discount_badge.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../view_models/store_view_model.dart';

// 충전 상품 선택. 결제하기를 누르면 true를 돌려주고 닫힌다.
// 원하는 금액으로 충전하기는 정책이 정해지면 단다.
class ChargeSheet extends StatelessWidget {
  const ChargeSheet(this.viewModel, {super.key});

  final StoreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final order = viewModel.order;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.gutter,
              0,
              AppSpace.gutter,
              12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '충전 상품 선택',
                        style: AppText.section.copyWith(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      tooltip: '닫기',
                      icon: const SvgIcon(
                        AppIcons.close,
                        size: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // 상품이 많으면 이 목록만 스크롤한다.
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: order.store.chargeProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final product = order.store.chargeProducts[index];
                      return _ProductRow(
                        product,
                        quantity: viewModel.quantityOf(product),
                        onQuantityChanged: (quantity) =>
                            viewModel.setQuantity(product, quantity),
                      );
                    },
                  ),
                ),
                _Summary(order),
                PrimaryButton(
                  label: order.priceWon > 0
                      ? '${formatNumber(order.priceWon)}원 결제하기'
                      : '충전 상품을 골라 주세요',
                  onPressed: order.priceWon > 0
                      ? () => Navigator.pop(context, true)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow(
    this.product, {
    required this.quantity,
    required this.onQuantityChanged,
  });

  final ChargeProduct product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final amount = '${formatNumber(product.amount)}P';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: AppText.section.copyWith(
                    letterSpacing: -0.3,
                    fontFeatures: tabularFigures,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatNumber(product.priceWon)}원 결제',
                  style: AppText.label.copyWith(
                    color: AppColors.textSecondary,
                    fontFeatures: tabularFigures,
                  ),
                ),
                if (product.discountRate > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DiscountBadge('${product.discountRate}% 할인'),
                  ),
              ],
            ),
          ),
          QuantityStepper(
            label: amount,
            quantity: quantity,
            max: ChargeLine.maxQuantity,
            onChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}

// 충전 포인트와 결제 금액,
class _Summary extends StatelessWidget {
  const _Summary(this.order);

  final ChargeOrder order;

  @override
  Widget build(BuildContext context) {
    final label = AppText.label.copyWith(color: AppColors.textSecondary);

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            children: [
              Expanded(child: Text('충전 포인트', style: label)),
              Text(
                '${formatNumber(order.amount)}P',
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: tabularFigures,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(child: Text('결제 금액', style: label)),
              if (order.savedWon > 0)
                _SavedBadge('${formatNumber(order.savedWon)}원 아껴요'),
              Text(
                '${formatNumber(order.priceWon)}원',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  fontFeatures: tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 아끼는 금액은 완료 배지 색(초록)으로 그린다.
class _SavedBadge extends StatelessWidget {
  const _SavedBadge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        text,
        style: AppText.badge.copyWith(
          color: AppColors.successText,
          fontFeatures: tabularFigures,
        ),
      ),
    );
  }
}
