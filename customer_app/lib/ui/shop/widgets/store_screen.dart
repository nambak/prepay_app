import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/tokens.dart';
import '../../core/widgets/load_error.dart';
import '../view_models/store_view_model.dart';
import 'charge_product_list.dart';
import 'store_contact.dart';
import 'store_hero.dart';
import 'store_info.dart';

// 가게 상세
class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.viewModel});

  final StoreViewModel viewModel;

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
              ChargeProductList(store.chargeProducts),
            ],
          );
        },
      ),
    );
  }
}
