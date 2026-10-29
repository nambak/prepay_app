import 'package:flutter/material.dart';
import 'package:prepay_app/domain/models/cash.dart';

import '../tokens.dart';

extension CashTypeUi on CashType {
  String get label => switch (this) {
    CashType.charge => '충전캐시',
    CashType.shared => '공유캐시',
    CashType.service => '서비스캐시',
  };

  Color get color => switch (this) {
    CashType.charge => AppColors.cashCharge,
    CashType.shared => AppColors.cashShared,
    CashType.service => AppColors.cashService,
  };
}

// 캐시 종류는 나타내느 점
class CashDot extends StatelessWidget {
  const CashDot(this.type, {super.key});

  final CashType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: type.color, shape: BoxShape.circle),
    );
  }
}
