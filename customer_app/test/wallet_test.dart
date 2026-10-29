import 'package:flutter_test/flutter_test.dart';
import 'package:prepay_app/data/repositories/cash_repository.dart';
import 'package:prepay_app/ui/core/format.dart';
import 'package:prepay_app/ui/wallet_pay/view_models/wallet_view_model.dart';

void main() {
  test('숫자에 쉼표를 넣는다', () {
    expect(formatNumber(500000), '500,000');
    expect(formatNumber(999), '999');
  });

  test('지갑을 불러오고 캐시 상세를 접고 편다', () async {
    final viewModel = WalletViewModel(cashRepository: CashRepository());
    expect(viewModel.loading, isTrue);

    await viewModel.load();
    expect(viewModel.wallet!.total, 500000);

    final first = viewModel.wallet!.stores.first.id;
    expect(viewModel.expandedStoreId, first);
    viewModel.toggleDetail(first);
    expect(viewModel.expandedStoreId, isNull);
  });
}
