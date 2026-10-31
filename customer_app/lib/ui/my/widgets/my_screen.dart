import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prepay_app/ui/core/icons.dart';
import 'package:prepay_app/ui/core/widgets/app_tab_bar.dart';

import '../../../routing/routes.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void openSettings() => context.push(Routes.settings);

    return Scaffold(
      bottomNavigationBar: const AppTabBar(current: AppTab.my),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 8, 8, 0),
              child: SizedBox(
                height: AppSize.appBar,
                child: Row(
                  children: [
                    const Expanded(child: Text('내 정보', style: AppText.title)),
                    IconButton(
                      onPressed: openSettings,
                      tooltip: '환경설정',
                      icon: const SvgIcon(AppIcons.settings, color: AppColors.textPrimary),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.gutter, 20, AppSpace.gutter, 8),
              child: Semantics(
                header: true,
                child: Text(
                  '계정',
                  style: AppText.secondary.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            AppCard(
              radius: AppRadius.card,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Semantics(
                button: true,
                child: InkWell(
                  onTap: openSettings,
                  child: const SizedBox(
                    height: AppSize.button,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('환경설정', style: AppText.input),
                          ),
                          SvgIcon(AppIcons.chevronRight, size: 18, color: AppColors.iconMuted, strokeWidth: 2),
                        ],
                      ),
                    ),
                  )
                )
              ),
            )
          ],
        ),
      )
    );
  }
}
