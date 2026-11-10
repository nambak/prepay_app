import 'package:flutter/material.dart';

import '../../../domain/models/store.dart';
import '../../core/tokens.dart';
import '../../core/widgets/discount_badge.dart';
import '../../core/widgets/store_thumb.dart';

class StoreRow extends StatelessWidget {
  const StoreRow(this.store, {super.key, required this.onTap});

  final StoreSummary store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rate = store.maxDiscountRate;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 104,
        child: Row(
          spacing: 14,
          children: [
            StoreThumb(
              store.kind,
              size: 68,
              radius: AppRadius.chip,
              iconSize: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    store.name,
                    style: AppText.inputBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    store.kind.label,
                    style: AppText.secondary.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (rate != null && rate > 0)
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: DiscountBadge('최대 $rate%'),
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
