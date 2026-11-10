import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/format.dart';
import '../../core/tokens.dart';
import '../../core/widgets/load_error.dart';
import '../../core/widgets/primary_button.dart';
import '../view_models/store_view_model.dart';
import 'charge_product_list.dart';
import 'charge_sheet.dart';
import 'store_contact.dart';
import 'store_hero.dart';
import 'store_info.dart';

// 가게 상세
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.viewModel});

  final StoreViewModel viewModel;

  // 충전 상품 선택에서 결제하기를 누르면 충전 결제로 간다.
  Future<void> _openChargeSheet(BuildContext context) async {
    final checkout = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ChargeSheet(viewModel),
    );

    if (checkout == true && context.mounted) {
      context.push(Routes.charge(viewModel.storeId), extra: viewModel.order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      // 대표 사진 자리가 화면 맨 위까지 올라가고, 뒤로 버튼은 그 위에 떠 있다.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        // 배경이 투명하면 상태 표시줄 글자가 흰색이 돼서, 밝은 대표 사진 자리 위에서 보이게 어둡게 둔다.
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: BackButton(
          style: IconButton.styleFrom(backgroundColor: AppColors.surface),
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final store = viewModel.store;
          if (store == null) {
            return viewModel.failed
                ? LoadError('가게를 불러오지 못했어요.', onRetry: viewModel.load)
                : const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom + 24,
            ),
            children: [
              StoreHero(store.kind),
              StoreInfo(store),
              StoreContact(address: store.address, phone: store.phone),
              const SizedBox(height: 12),
              Container(height: 8, color: AppColors.bgPage),
              ChargeProductList(
                store.chargeProducts,
                quantityOf: viewModel.quantityOf,
                onQuantityChanged: viewModel.setQuantity,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.store?.chargeProducts.isNotEmpty != true) {
            return const SizedBox.shrink();
          }
          final priceWon = viewModel.order.priceWon;
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.gutter,
                  12,
                  AppSpace.gutter,
                  12,
                ),
                child: PrimaryButton(
                  label: priceWon > 0
                      ? '${formatNumber(priceWon)}원 충전하기'
                      : '충전 상품을 골라 주세요',
                  onPressed: priceWon > 0
                      ? () => _openChargeSheet(context)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
