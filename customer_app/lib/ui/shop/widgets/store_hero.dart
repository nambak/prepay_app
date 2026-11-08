import 'package:flutter/material.dart';

import '../../../domain/models/store.dart';
import '../../core/icons.dart';
import '../../core/widgets/store_thumb.dart';

// 대표 사진 자리. 사진이 생기기 전까지 업종 아이콘을 보여 준다.
class StoreHero extends StatelessWidget {
  const StoreHero(this.kind, {super.key});

  final StoreKind kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: kind.tone.bg,
      alignment: Alignment.center,
      child: SvgIcon(kind.icon, size: 96, color: kind.tone.fg, strokeWidth: 1),
    );
  }
}
