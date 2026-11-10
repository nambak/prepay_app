import 'package:flutter/material.dart';

import '../../../domain/models/store.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/store_thumb.dart';

class StoreInfo extends StatelessWidget {
  const StoreInfo(this.store, {super.key});

  final StoreDetail store;

  @override
  Widget build(BuildContext context) {
    final rate = store.maxDiscountRate;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpace.gutter, 20, AppSpace.gutter, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          Text(store.name, style: AppText.title.copyWith(letterSpacing: -0.4)),
          Text(
            store.kind.label,
            style: AppText.label.copyWith(color: AppColors.textMuted),
          ),
          if (rate != null && rate > 0) _DiscountBox(rate),
        ],
      ),
    );
  }
}

class _DiscountBox extends StatelessWidget {
  const _DiscountBox(this.rate);

  final int rate;

  @override
  Widget build(BuildContext context) {
    final discount = TextStyle(color: AppColors.discountText);

    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.discountBg,
        borderRadius: BorderRadius.circular(AppRadius.cardSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  '충전하면 최대 $rate% 할인',
                  style: AppText.inputBold.merge(discount),
                ),
                Text(
                  '충전한 포인트로 이 가게에서 바로 결제해요',
                  style: AppText.secondary.merge(discount),
                ),
              ],
            ),
          ),
          SvgIcon(
            AppIcons.coin,
            size: 28,
            color: AppColors.discountText,
            strokeWidth: 1.7,
          ),
        ],
      ),
    );
  }
}
