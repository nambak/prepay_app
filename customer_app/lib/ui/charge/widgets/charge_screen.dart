import 'package:material_ui/material_ui.dart';

import '../../core/tokens.dart';
import '../view_models/charge_view_model.dart';
import 'charge_amount_card.dart';
import 'charge_bottom_bar.dart';
import 'charge_done_screen.dart';
import 'charge_notice.dart';
import 'charge_order_card.dart';

// 충전 결제. 결제가 끝나면 같은 자리에 충전 완료를 보여 준다.
class ChargeScreen extends StatelessWidget {
  const ChargeScreen({super.key, required this.viewModel});

  final ChargeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.receipt case final receipt?) {
          return ChargeDoneScreen(receipt);
        }
        final order = viewModel.order;

        // 결제 요청 중에는 화면을 닫지 않는다. 닫아도 요청은 계속 가서 충전될 수 있다.
        return PopScope(
          canPop: !viewModel.submitting,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.bgPage,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text('포인트 충전', style: AppText.cardTitle),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 8, bottom: 24),
                    children: [
                      ChargeOrderCard(order),
                      SizedBox(height: 12),
                      ChargeAmountCard(order),
                      SizedBox(height: 12),
                      ChargeNotice(
                        agreed: viewModel.agreed,
                        onAgreeChanged: viewModel.agree,
                      ),
                    ],
                  ),
                ),
                ChargeBottomBar(
                  priceWon: order.priceWon,
                  error: viewModel.error,
                  submitting: viewModel.submitting,
                  onPay: viewModel.agreed ? viewModel.pay : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
