import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prepay_app/routing/router.dart';
import 'package:prepay_app/routing/routes.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/widgets/app_tab_bar.dart';
import 'package:prepay_app/ui/core/widgets/coming_soon_screen.dart';

void main() {
  testWidgets('아직 없는 탭을 눌러도 오류 없이 준비 중 화면을 보여준다', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'auth_token': '1|abc'});
    await authRepository.load();
    router.go(Routes.my);

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    for (final tab in [AppTab.home, AppTab.like]) {
      await tester.tap(find.text(tab.label).last);
      await tester.pumpAndSettle();

      expect(find.text('준비 중이에요'), findsOneWidget);
      expect(
        tester.widget<ComingSoonScreen>(find.byType(ComingSoonScreen)).tab,
        tab,
      );
    }
  });
}
