import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';
import '../../../domain/models/store.dart';
import '../../core/format.dart';
import '../../core/icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/app_card.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            spacing: 12,
            children: [
              _StoreThumb(store.kind),
              Expanded(
                child: InkWell(
                  onTap: () {}, // TODO: 가게
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
                        '${store.visitCount}번째 방문 · ${formatNumber(store.savedWon)}원 아낌',
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
                  fixedSize: const Size.square(AppSize.touchTarget),
                ),
                icon: const SvgIcon(
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
                    const TextSpan(text: 'P', style: TextStyle(fontSize: 15)),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                  fontFeatures: tabularFigures,
                ),
              ),
            ],
          ),
          // TODO: 쓰기 05-03, 충전 04-05, 공유 06-01 화면을 만들면 연결
          const Row(
            spacing: 8,
            children: [
              Expanded(flex: 3, child: _CardButton('쓰기', primary: true)),
              Expanded(flex: 2, child: _CardButton('충전')),
              Expanded(flex: 2, child: _CardButton('공유')),
            ],
          ),
          PointDetail(store, expanded: expanded, onToggle: onToggleDetail),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton(this.label, {this.primary = false});

  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSize.buttonSm),
        backgroundColor: primary ? AppColors.buttonRed : AppColors.bgField,
        foregroundColor: primary ? AppColors.surface : AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.buttonSm),
        ),
      ),
      // 글자 스타일은 textStyle 대신 Text 에 줘요. (textStyle 은 Pretendard 지정을 덮어써요)
      child: Text(
        label,
        style: primary
            ? AppText.input.copyWith(fontWeight: FontWeight.w700)
            : AppText.body.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _StoreThumb extends StatelessWidget {
  const _StoreThumb(this.kind);

  final StoreKind kind;

  @override
  Widget build(BuildContext context) {
    // 시안에서 업종별로 가장 많이 쓴 색이에요.
    final (tone, icon) = switch (kind) {
      StoreKind.cafe => (AppTone.a, AppIcons.cafe),
      StoreKind.food => (AppTone.b, AppIcons.food),
      StoreKind.bakery => (AppTone.c, AppIcons.bakery),
      StoreKind.beauty => (AppTone.d, AppIcons.beauty),
      StoreKind.shop => (AppTone.a, AppIcons.store),
    };
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: SvgIcon(icon, color: tone.fg, strokeWidth: 1.6),
    );
  }
}
