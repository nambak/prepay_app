import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart' show Routes;
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_tab_bar.dart';
import '../../core/widgets/load_error.dart';
import '../view_models/shop_view_model.dart';
import 'store_row.dart';

// 가게찾기
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, required this.viewModel});

  final ShopViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppTabBar(current: AppTab.shop),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.gutter,
                8,
                AppSpace.gutter,
                0,
              ),
              child: SizedBox(
                height: AppSize.appBar,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('가게찾기', style: AppText.title),
                ),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  final stores = viewModel.stores;
                  if (stores == null) {
                    return viewModel.failed
                        ? LoadError('가게를 불러오지 못했어요', onRetry: viewModel.load)
                        : Center(child: CircularProgressIndicator());
                  }
                  if (stores.isEmpty) {
                    return Center(
                      child: Text(
                        '아직 가게가 없어요',
                        style: AppText.body.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.only(top: 8, bottom: 24),
                    children: [
                      AppCard(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpace.gutter,
                        ),
                        child: Column(
                          children: [
                            for (final (index, store) in stores.indexed) ...[
                              if (index > 0)
                                Divider(
                                  height: 1,
                                  color: AppColors.borderInner,
                                ),
                              StoreRow(
                                store,
                                onTap: () =>
                                    context.push(Routes.store(store.id)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
