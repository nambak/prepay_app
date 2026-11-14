import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prepay_app/data/repositories/point_repository.dart';
import 'package:prepay_app/data/services/api_client.dart';
import 'package:prepay_app/domain/models/store.dart';
import 'package:prepay_app/ui/core/format.dart';
import 'package:prepay_app/ui/wallet_pay/view_models/wallet_view_model.dart';

// 서버 WalletController 와 같은 모양의 응답
const _walletJson = {
  'charge': 320000,
  'shared': 150000,
  'service': 30000,
  'saved_won': 32500,
  'stores': [
    {
      'id': 1,
      'name': '행복식당 1',
      'kind': 'food',
      'visit_count': 12,
      'saved_won': 8400,
      'items': [
        {'type': 'charge', 'amount': 150000, 'days_left': null},
        {'type': 'shared', 'amount': 100000, 'days_left': 100},
        {'type': 'service', 'amount': 30000, 'days_left': 365},
      ],
    },
    {
      'id': 2,
      'name': '하루카페2',
      'kind': 'cafe',
      'visit_count': 3,
      'saved_won': 2500,
      'items': [
        {'type': 'charge', 'amount': 100000, 'days_left': null},
      ],
    },
  ],
};

WalletViewModel _viewModelReturning(http.Response response) => WalletViewModel(
  pointRepository: PointRepository(
    apiClient: ApiClient(
      baseUrl: 'http://test',
      client: MockClient((_) async => response),
    ),
  ),
);

void main() {
  test('숫자에 쉼표를 넣는다', () {
    expect(formatNumber(500000), '500,000');
    expect(formatNumber(999), '999');
  });

  test('일시는 기기 시간대와 상관없이 서울 시간으로 보여 준다', () {
    // 서버는 +09:00으로 주지만 DateTime.parse는 UTC로 바꿔 둔다
    expect(
      formatDateTime(DateTime.parse('2026-10-27T12:00:00+09:00')),
      '2026.10.27 12:00',
    );
    expect(
      formatDateTime(DateTime.utc(2026, 10, 27, 20, 30)),
      '2026.10.28 05:30',
    );
  });

  test('지갑을 불러오고 포인트 상세를 접고 편다', () async {
    // 한글이 들어 있어서 utf8바이트로 응답을 만든다.
    final viewModel = _viewModelReturning(
      http.Response.bytes(utf8.encode(jsonEncode(_walletJson)), 200),
    );
    expect(viewModel.loading, isTrue);

    await viewModel.load();
    final wallet = viewModel.wallet!;
    expect(wallet.total, 500000);
    expect(wallet.stores.first.id, 1);
    expect(wallet.stores.first.kind, StoreKind.food);

    final first = wallet.stores.first.id;
    expect(viewModel.expandedStoreId, first);
    viewModel.toggleDetail(first);
    expect(viewModel.expandedStoreId, isNull);
  });

  test('서버가 실패하면 실패 상태가 된다', () async {
    final viewModel = _viewModelReturning(http.Response('', 500));

    await viewModel.load();
    expect(viewModel.failed, isTrue);
    expect(viewModel.loading, isFalse);
    expect(viewModel.wallet, isNull);
  });
}
