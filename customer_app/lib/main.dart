import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'routing/router.dart';
import 'ui/core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 저장해 둔 토큰을 먼저 읽어야, 첫 화면을 로그인으로 보낼지 정할 수 있다.
  await authRepository.load();
  runApp(
    MaterialApp.router(
      theme: appTheme,
      routerConfig: router,
      // 뒤로 버튼 툴팁처럼 Flutter가 넣는 문구도 한국어로 보여 준다(스크린 리더가 'Back' 대신 '뒤로'로 읽음)
      locale: Locale('ko'),
      supportedLocales: [Locale('ko')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    ),
  );
}
