import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepay_app/domain/models/point.dart';
import 'package:prepay_app/domain/models/store.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/wallet_pay/widgets/store_card.dart';

Widget _card({required int visitCount}) => MaterialApp(
  theme: appTheme,
  home: Scaffold(
    body: StoreCard(
      StoreWallet(
        id: '2',
        name: '하루카페2',
        kind: StoreKind.cafe,
        visitCount: visitCount,
        savedWon: 2500,
        items: const [PointItem(PointType.charge, 20000, daysLeft: 365)],
      ),
      expanded: false,
      onToggleDetail: () {},
    ),
  ),
);

void main() {
  testWidgets('방문 횟수가 0이면 아낀 금액만 보여준다', (tester) async {
    await tester.pumpWidget(_card(visitCount: 0));
    expect(find.text('2,500원 아낌'), findsOneWidget);

    await tester.pumpWidget(_card(visitCount: 3));
    expect(find.text('3번째 방문 · 2,500원 아낌'), findsOneWidget);
  });
}
