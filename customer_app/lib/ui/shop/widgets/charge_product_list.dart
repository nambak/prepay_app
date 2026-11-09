import 'package:flutter/material.dart';

import '../../../domain/models/store.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/discount_badge.dart';

// 충전 상품 목록. 상품이 없으면 안내 문구를 보여 준다.
class ChargeProductList extends StatelessWidget {
  const ChargeProductList(this.products, {super.key});

  final List<ChargeProduct> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.gutter,
        24,
        AppSpace.gutter,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          const Text('충전 상품', style: AppText.section),
          if (products.isEmpty)
            Text(
              '아직 충전 상품이 없어요',
              style: AppText.body.copyWith(color: AppColors.textMuted),
            ),
          for (final product in products) _ChargeProductCard(product),
        ],
      ),
    );
  }
}

// 충전 상품 하나. 수량 고르기와 충전하기는 충전 기능을 만들 때 단다.
class _ChargeProductCard extends StatelessWidget {
  const _ChargeProductCard(this.product);

  final ChargeProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgField,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: formatNumber(product.amount)),
                const TextSpan(text: 'P', style: TextStyle(fontSize: 15)),
              ],
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              fontFeatures: tabularFigures,
            ),
          ),
          Text(
            '${formatNumber(product.priceWon)}원에 충전',
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
          if (product.discountRate > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: DiscountBadge('${product.discountRate}% 할인'),
            ),
        ],
      ),
    );
  }
}
