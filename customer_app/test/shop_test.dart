// 서버 StoreController와 같은 모양의 응답
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/store_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/ui/core/theme.dart';
import 'package:prepay_app/ui/shop/view_models/shop_view_model.dart';
import 'package:prepay_app/ui/shop/view_models/store_view_model.dart';
import 'package:prepay_app/ui/shop/widgets/shop_screen.dart';
import 'package:prepay_app/ui/shop/widgets/store_screen.dart';

const _storesJson = {
  'stores': [
    {'id': 2, 'name': '하루카페2', 'kind': 'cafe', 'max_discount_rate': 20},
    {'id': 5, 'name': '아침베이커리', 'kind': 'bakery', 'max_discount_rate': null},
  ],
};

const _storeJson = {
  'id': 2,
  'name': '하루카페2',
  'kind': 'cafe',
  'address': '서울시 행복구 하늘로 12 2층',
  'phone': null,
  'charge_products': [
    {'id': 3, 'amount': 50000, 'price_won': 47500, 'discount_rate': 5},
    {'id': 4, 'amount': 100000, 'price_won': 80000, 'discount_rate': 20},
  ],
};

StoreRepository _repositoryReturning(Map<String, Object?> json) =>
    StoreRepository(
      apiClient: ApiClient(
        baseUrl: 'http://test',
        // 한글이 들어 있어서 utf8 바이트로 응답을 만든다.
        client: MockClient(
          (_) async => http.Response.bytes(utf8.encode(jsonEncode(json)), 200),
        ),
      ),
    );

void main() {
  testWidgets('가게 목록은 할인율이 있는 가게에만 할인 배지를 보여 준다.', (tester) async {
    final viewModel = ShopViewModel(
      storeRepository: _repositoryReturning(_storesJson),
    )..load();

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: ShopScreen(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('하루카페2'), findsOneWidget);
    expect(find.text('카페'), findsOneWidget);
    expect(find.text('최대 20%'), findsOneWidget);
    expect(find.text('아침베이커리'), findsOneWidget);
    expect(find.textContaining('최대'), findsOneWidget);
  });

  testWidgets('가게 상세는 주소와 충전 상품을 보여 주고, 없는 전화는 숨긴다', (tester) async {
    // 시안과 같은 390x844 화면. 기본 800x600에서는 충전 상품이 아직 그려지지 않는다.
    tester.view.physicalSize = Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final viewModel = StoreViewModel(
      storeRepository: _repositoryReturning(_storeJson),
      storeId: 2,
    )..load();

    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme,
        home: StoreScreen(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('충전하면 최대 20% 할인'), findsOneWidget);
    expect(find.text('서울시 행복구 하늘로 12 2층'), findsOneWidget);
    expect(find.text('50,000P'), findsOneWidget);
    expect(find.text('47,500원에 충전'), findsOneWidget);
    expect(find.text('5% 할인'), findsOneWidget);
    expect(find.text('20% 할인'), findsOneWidget);
    expect(find.text('복사'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    await tester.tap(find.text('복사'));
    await tester.pump();
    expect(find.text('주소를 복사했어요'), findsOneWidget);
  });
}
