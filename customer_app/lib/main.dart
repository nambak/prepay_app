import 'package:flutter/material.dart';

import 'routing/router.dart';
import 'ui/core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 저장해 둔 토큰을 먼저 읽어야, 첫 화면을 로그인으로 보낼지 정할 수 있다.
  await authRepository.load();
  runApp(MaterialApp.router(theme: appTheme, routerConfig: router,));
}

