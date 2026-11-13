import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../routing/routes.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';

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
        title: Text('환경설정', style: AppText.cardTitle),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 12, bottom: 24),
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
                    padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '로그아웃',
                        style: AppText.inputMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.gutter,
              12,
              AppSpace.gutter,
              0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => context.push(Routes.withdraw),
                style: TextButton.styleFrom(
                  minimumSize: Size(0, AppSize.touchTarget),
                  foregroundColor: AppColors.textMuted,
                ),
                child: Text(
                  '회원 탈퇴',
                  style: AppText.secondary.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
