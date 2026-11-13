import 'package:material_ui/material_ui.dart';

import '../../../domain/models/store.dart';
import '../icons.dart';
import '../tokens.dart';

// 업종 이름, 썸네일 색과 아이콘.
extension StoreKindLook on StoreKind {
  String get label => switch (this) {
    StoreKind.cafe => '카페',
    StoreKind.food => '음식점',
    StoreKind.bakery => '베이커리',
    StoreKind.beauty => '뷰티',
    StoreKind.shop => '일반 가게',
  };

  AppTone get tone => switch (this) {
    StoreKind.cafe || StoreKind.shop => AppTone.a,
    StoreKind.food => AppTone.b,
    StoreKind.bakery => AppTone.c,
    StoreKind.beauty => AppTone.d,
  };

  String get icon => switch (this) {
    StoreKind.cafe => AppIcons.cafe,
    StoreKind.food => AppIcons.food,
    StoreKind.bakery => AppIcons.bakery,
    StoreKind.beauty => AppIcons.beauty,
    StoreKind.shop => AppIcons.store,
  };
}

// 업종 썸네일. 가게 사진이 생기기 전까지 업종 아이콘을 보여 준다.
class StoreThumb extends StatelessWidget {
  const StoreThumb(
    this.kind, {
    super.key,
    this.size = 48,
    this.radius = AppRadius.field,
    this.iconSize = 24,
  });

  final StoreKind kind;
  final double size;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kind.tone.bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SvgIcon(
        kind.icon,
        size: iconSize,
        color: kind.tone.fg,
        strokeWidth: 1.6,
      ),
    );
  }
}
