import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/point.dart';
import '../../../routing/routes.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/store_thumb.dart';
import 'point_detail.dart';

/// 가게 한 곳의 카드: 가게 정보, 포인트 합계, 쓰기·충전·공유 버튼, 포인트 상세
class StoreCard extends StatelessWidget {
  const StoreCard(
    this.store, {
    super.key,
    required this.expanded,
    required this.onToggleDetail,
  });

  final StoreWallet store;
  final bool expanded;
  final VoidCallback onToggleDetail;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            spacing: 12,
            children: [
              StoreThumb(store.kind),
              Expanded(
                child: InkWell(
                  onTap: () => context.push(Routes.store(store.id)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        store.name,
                        style: AppText.cardTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        // 쓰기 기록이 생기기 전에는 방문 횟수가 0이라 숨긴다.
                        [
                          if (store.visitCount > 0) '${store.visitCount}번째 방문',
                          '${formatNumber(store.savedWon)}원 아낌',
                        ].join(' · '),
                        style: AppText.secondary.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {}, // TODO: 전화 걸기
                tooltip: '${store.name}에 전화 걸기',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bgField,
                  fixedSize: Size.square(AppSize.touchTarget),
                ),
                icon: SvgIcon(
                  AppIcons.phone,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  '쓸 수 있는 포인트',
                  style: AppText.label.copyWith(color: AppColors.textSecondary),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: formatNumber(store.total)),
                    TextSpan(text: 'P', style: TextStyle(fontSize: 15)),
                  ],
                ),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  fontFeatures: tabularFigures,
                ),
              ),
            ],
          ),
          // TODO: 쓰기 05-03, 공유 06-01 화면을 만들면 연결
          Row(
            spacing: 8,
            children: [
              Expanded(
                flex: 3,
                child: _CardButton('쓰기', primary: true, onPressed: () {}),
              ),
              Expanded(
                flex: 2,
                // 충전 상품은 가게 상세에서 고른다
                child: _CardButton(
                  '충전',
                  onPressed: () => context.push(Routes.store(store.id)),
                ),
              ),
              Expanded(flex: 2, child: _CardButton('공유', onPressed: () {})),
            ],
          ),
          PointDetail(store, expanded: expanded, onToggle: onToggleDetail),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton(
    this.label, {
    this.primary = false,
    required this.onPressed,
  });

  final String label;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(AppSize.buttonSm),
        backgroundColor: primary ? AppColors.buttonRed : AppColors.bgField,
        foregroundColor: primary ? AppColors.surface : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.buttonSm),
        ),
      ),
      // 글자 스타일은 textStyle 대신 Text 에 줘요. (textStyle 은 Pretendard 지정을 덮어써요)
      child: Text(
        label,
        style: primary ? AppText.inputBold : AppText.bodyMedium,
      ),
    );
  }
}
