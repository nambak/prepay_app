import 'package:flutter/material.dart';

import '../../../domain/models/point.dart';

import '../tokens.dart';

extension PointTypeUi on PointType {
  String get label => switch (this) {
    PointType.charge => '충전포인트',
    PointType.shared => '공유포인트',
    PointType.service => '서비스포인트',
  };

  Color get color => switch (this) {
    PointType.charge => AppColors.pointCharge,
    PointType.shared => AppColors.pointShared,
    PointType.service => AppColors.pointService,
  };
}

// 포인트 종류를 나타내는 점
class PointDot extends StatelessWidget {
  const PointDot(this.type, {super.key});

  final PointType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: type.color, shape: BoxShape.circle),
    );
  }
}
