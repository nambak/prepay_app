import 'package:material_ui/material_ui.dart';

import '../../../domain/models/charge.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/discount_badge.dart';
import '../../core/widgets/store_thumb.dart';

// 충전할 가게와 상품
class ChargeOrderCard extends StatelessWidget {
  const ChargeOrderCard(this.order, {super.key});

  final ChargeOrder order;

  @override
  Widget build(BuildContext context) {
    final store = order.store;

    return AppCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 12,
            children: [
              StoreThumb(store.kind, size: 44, iconSize: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(store.name, style: AppText.cardTitle),
                    Text(
                      store.kind.label,
                      style: AppText.secondary.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(height: 1, color: AppColors.borderInner),
          SizedBox(height: 16),
          Text('충전 상품', style: AppText.bodyBold),
          SizedBox(height: 4),
          for (final (index, line) in order.lines.indexed) ...[
            if (index > 0) Divider(height: 1, color: AppColors.borderInner),
            _LineRow(line),
          ],
        ],
      ),
    );
  }
}

// 상품 한 줄: 포인트 × 수량, 할인 배지, 결제 금액
class _LineRow extends StatelessWidget {
  const _LineRow(this.line);

  final ChargeLine line;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 48),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Text(
              '${formatNumber(line.product.amount)}P × ${line.quantity}',
              style: AppText.body.copyWith(fontFeatures: tabularFigures),
            ),
          ),
          if (line.product.discountRate > 0)
            DiscountBadge('${line.product.discountRate}% 할인'),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 84),
            child: Text(
              '${formatNumber(line.priceWon)}원',
              textAlign: TextAlign.right,
              style: AppText.bodyBold.copyWith(fontFeatures: tabularFigures),
            ),
          ),
        ],
      ),
    );
  }
}
