import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../routing/routes.dart';
import '../icons.dart';
import '../tokens.dart';

enum AppTab {
  home('홈', AppIcons.home, Routes.home),
  shop('가게찾기', AppIcons.shop, Routes.shop),
  wallet('내 가게', AppIcons.wallet, Routes.wallet),
  like('좋아요', AppIcons.heart, Routes.likes),
  my('내 정보', AppIcons.my, Routes.my);

  const AppTab(this.label, this.icon, this.path);

  final String label;
  final String icon;
  final String path;
}

// 하단 탭바. 화면에서는 Scaffold(bottomNavigationBar: AppTabBar(current: AppTab.wallet))로 사용.
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.current});

  final AppTab current;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              for (final tab in AppTab.values)
                Expanded(child: _TabItem(tab, selected: tab == current)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem(this.tab, {required this.selected});

  final AppTab tab;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textPrimary : AppColors.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: () => context.go(tab.path),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 3,
          children: [
            SvgIcon(tab.icon, color: color, strokeWidth: selected ? 2.2 : 1.7),
            Text(
              tab.label,
              style: AppText.badge.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
