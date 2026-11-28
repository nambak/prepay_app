import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/point_history.dart';
import '../../../routing/routes.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_tab_bar.dart';

class MyScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    void openSettings() => context.push(Routes.settings);

    return Scaffold(
      bottomNavigationBar: AppTabBar(current: AppTab.my),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpace.gutter, 8, 8, 0),
              child: SizedBox(
                height: AppSize.appBar,
                child: Row(
                  children: [
                    Expanded(child: Text('내 정보', style: AppText.title)),
                    IconButton(
                      onPressed: openSettings,
                      tooltip: '환경설정',
                      icon: SvgIcon(
                        AppIcons.settings,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _GroupTitle('나의 포인트'),
            AppCard(
              radius: AppRadius.card,
              padding: EdgeInsets.symmetric(vertical: 4),
              child: _MenuRow(
                '가게 이용내역',
                onTap: () => context.push(Routes.history(HistoryTab.uses)),
              ),
            ),
            _GroupTitle('계정'),
            AppCard(
              radius: AppRadius.card,
              padding: EdgeInsets.symmetric(vertical: 4),
              child: _MenuRow('환경설정', onTap: openSettings),
            ),
          ],
        ),
      ),
    );
  }
}

// 메뉴 묶음의 이름
class _GroupTitle extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpace.gutter, 20, AppSpace.gutter, 8),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: AppText.secondaryMedium.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

// 메뉴 한 줄. 누르면 그 화면으로
class _MenuRow extends StatelessWidget {
  const new(this.label, {required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSize.button,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpace.gutter),
            child: Row(
              children: [
                Expanded(child: Text(label, style: AppText.input)),
                SvgIcon(
                  AppIcons.chevronRight,
                  size: 18,
                  color: AppColors.iconMuted,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
