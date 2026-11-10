import 'package:flutter/material.dart';

import '../../../domain/models/charge.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';

class ChargeAmountCard extends StatelessWidget {
  const ChargeAmountCard(this.order, {super.key});

  final ChargeOrder order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            '결제 금액',
            style: AppText.body.copyWith(fontWeight: FontWeight.w700),
          ),
          _AmountRow('충전 포인트', '${formatNumber(order.amount)}P'),
          _AmountRow('상품 금액', '${formatNumber(order.listPriceWon)}원'),
          _AmountRow('할인 금액', '−${formatNumber(order.savedWon)}원'),
          SizedBox(height: 4),
          Divider(height: 1, color: AppColors.borderInner),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  '최종 결제 금액',
                  style: AppText.input.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${formatNumber(order.priceWon)}원',
                style: AppText.title.copyWith(
                  letterSpacing: -0.6,
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

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: AppText.body.copyWith(
            fontWeight: FontWeight.w500,
            fontFeatures: tabularFigures,
          ),
        ),
      ],
    );
  }
}
