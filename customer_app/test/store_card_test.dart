import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:prepay_app/domain/models/point.dart';
import 'package:prepay_app/domain/models/store.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/wallet_pay/widgets/store_card.dart';

StoreWallet _store({int visitCount = 0}) => StoreWallet(
  id: 2,
  name: '하루카페2',
  kind: StoreKind.cafe,
  visitCount: visitCount,
  savedWon: 2500,
  items: [
    PointItem(PointType.charge, 20000),
    PointItem(PointType.service, 10000, daysLeft: 100),
  ],
);

Widget _card({required int visitCount, bool expanded = false}) => MaterialApp(
  theme: appTheme,
  home: Scaffold(
    body: StoreCard(
      _store(visitCount: visitCount),
      expanded: expanded,
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

  testWidgets('기한이 없는 충전포인트에는 D-day를 그리지 않는다', (tester) async {
    await tester.pumpWidget(_card(visitCount: 0, expanded: true));

    expect(find.text('D-100'), findsOneWidget);
    expect(find.textContaining('D-'), findsOneWidget);
  });

  testWidgets('충전을 누르면 가게 상세로 간다', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: StoreCard(_store(), expanded: false, onToggleDetail: () {}),
          ),
        ),
        GoRoute(
          path: '/shop/:id',
          builder: (_, state) => Text('가게 ${state.pathParameters['id']}'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: appTheme, routerConfig: router),
    );
    await tester.tap(find.text('충전'));
    await tester.pumpAndSettle();

    expect(find.text('가게 2'), findsOneWidget);
  });
}
