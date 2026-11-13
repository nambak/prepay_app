import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/view_model.dart';
import 'package:prepay_app/ui/core/widgets/labeled_field.dart';
import 'package:prepay_app/ui/core/widgets/primary_button.dart';
import 'package:prepay_app/ui/core/widgets/view_model_scope.dart';

// 테스트용 view model. 정한 때에 알린다.
class _TestViewModel extends ViewModel {
  Future<void> notifyAfter(Future<void> done) async {
    await done;
    notifyListeners();
  }
}

Widget _app(Widget child) => MaterialApp(
  theme: appTheme,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('입력창에 닿으면 라벨도 함께 읽는다', (tester) async {
    await tester.pumpWidget(
      _app(LabeledField(label: '이메일 아이디', child: TextField())),
    );

    expect(tester.getSemantics(find.byType(TextField)).label, '이메일 아이디');
  });

  testWidgets('기다리는 동안에는 눌러도 다시 보내지 않는다', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(PrimaryButton(label: '로그인', onPressed: () => taps++, loading: true)),
    );

    await tester.tap(find.byType(PrimaryButton));
    expect(taps, 0);
    expect(find.text('로그인'), findsNothing);
  });

  testWidgets('위에 화면을 열었다 닫아도 view model을 다시 만들지 않는다', (tester) async {
    var created = 0;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ViewModelScope(
            create: () {
              created++;
              return _TestViewModel();
            },
            builder: (_) => Scaffold(
              body: TextButton(
                onPressed: () => context.push('/next'),
                child: Text('열기'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/next',
          builder: (context, state) => Scaffold(
            body: TextButton(onPressed: () => context.pop(), child: Text('닫기')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();

    expect(created, 1);
  });

  testWidgets('화면을 닫으면 view model을 정리하고, 늦게 끝난 요청의 알림은 무시한다', (tester) async {
    final viewModel = _TestViewModel();
    final response = Completer<void>();
    await tester.pumpWidget(
      ViewModelScope(create: () => viewModel, builder: (_) => SizedBox()),
    );
    unawaited(viewModel.notifyAfter(response.future));

    // 요청이 끝나기 전에 화면을 닫는다.
    await tester.pumpWidget(SizedBox());
    expect(() => viewModel.addListener(() {}), throwsFlutterError);

    response.complete();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('view model을 만들다 실패하면 화면을 닫을 때 다시 만들지 않는다', (tester) async {
    var created = 0;
    await tester.pumpWidget(
      ViewModelScope<_TestViewModel>(
        create: () {
          created++;
          throw StateError('만들기 실패');
        },
        builder: (_) => SizedBox(),
      ),
    );
    expect(tester.takeException(), isStateError);

    await tester.pumpWidget(SizedBox());
    expect(tester.takeException(), isNull);
    expect(created, 1);
  });
}
