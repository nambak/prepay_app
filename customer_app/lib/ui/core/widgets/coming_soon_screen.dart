import 'package:flutter/material.dart';

import '../tokens.dart';
import 'app_tab_bar.dart';

// 아직 만들지 않은 탭 화면. 그 탭의 화면을 만들면 router.dart에서 실제 화면으로 바꾼다.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.tab});

  final AppTab tab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppTabBar(current: tab),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.gutter,
                8,
                AppSpace.gutter,
                0,
              ),
              child: SizedBox(
                height: AppSize.appBar,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(tab.label, style: AppText.title),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '준비 중이에요',
                  style: AppText.body.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
