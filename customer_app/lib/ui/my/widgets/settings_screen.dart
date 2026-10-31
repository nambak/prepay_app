import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prepay_app/ui/core/widgets/app_card.dart';

import '../../core/icons.dart';
import '../../core/tokens.dart';

// 환경설정. 지금은 로그아웃만 있다. 알림 설정은 저장할 서버가 생기면 넣는다
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onLogout});

  // 로그아웃하면 라우터가 로그인 화면으로 옮긴다
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgPage,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          tooltip: '뒤로 가기',
          icon: const SvgIcon(AppIcons.back, color: AppColors.textPrimary, strokeWidth: 2),
        ),
        title: const Text('환경설정', style: AppText.cardTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          AppCard(
            radius: AppRadius.card,
            padding: EdgeInsets.zero,
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: onLogout,
                child: SizedBox(
                  height: AppSize.button,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.gutter),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '로그아웃',
                        style: AppText.input.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary
                        ),
                      ),
                    ),
                  ),
                ),
              )
            )
          )
        ],
      )
    );
  }
}
