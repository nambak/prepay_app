import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prepay_app/routing/router.dart';
import 'package:prepay_app/routing/routes.dart';
import 'package:prepay_app/ui/account/widgets/login_screen.dart';
import 'package:prepay_app/ui/core/icons.dart';
import 'package:prepay_app/ui/core/theme.dart';

void main() {
  testWidgets('마이 > 환경설정에서 로그아웃하면 로그인 화면으로 간다', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'auth_token': '1|abc'});
    await authRepository.load();
    router.go(Routes.my);

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.tap(find.text('환경설정'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();

    expect(authRepository.isLoggedIn, false);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('하위 화면의 뒤로 버튼은 시안의 꺾쇠(SVG)를 쓴다', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'auth_token': '1|abc'});
    await authRepository.load();
    router.go(Routes.my);

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.tap(find.text('환경설정'));
    await tester.pumpAndSettle();

    final backIcon = find.descendant(
      of: find.byType(BackButton),
      matching: find.byType(SvgIcon),
    );
    expect(backIcon, findsOneWidget);
    expect(tester.widget<SvgIcon>(backIcon).paths, AppIcons.back);
  });
}
