import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/core/widgets/labeled_field.dart';
import 'package:prepay_app/ui/core/widgets/primary_button.dart';

Widget _app(Widget child) => MaterialApp(
  theme: appTheme,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('입력창에 닿으면 라벨도 함께 읽는다', (tester) async {
    await tester.pumpWidget(
      _app(const LabeledField(label: '이메일 아이디', child: TextField())),
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
}
