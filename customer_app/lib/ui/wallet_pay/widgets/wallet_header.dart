// '즐겨찾는 가게 | 그룹' 제목줄과 QR 버튼
import 'package:flutter/material.dart';

import '../../core/icons.dart';

import '../../core/tokens.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 8, 8, 0),
      child: SizedBox(
        height: AppSize.appBar,
        child: Row(
          spacing: 10,
          children: [
            Semantics(
              selected: true,
              child: const Text('즐겨찾는 가게', style: AppText.title),
            ),
            InkWell(
              onTap: () {}, // TODO: 그룹
              child: Text(
                '그룹',
                style: AppText.title.copyWith(color: AppColors.iconMuted),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {}, // TODO: QR
              tooltip: 'QR로 쓰기',
              icon: const SvgIcon(AppIcons.qr, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
