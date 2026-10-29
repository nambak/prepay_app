// 숫자 세자리 마다 쉼표
import 'dart:ui';

String formatNumber(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

// 숫자 폭을 고르게 맞춰서 금액 자리수가 흔들리지 않게함.
const tabularFigures = [FontFeature.tabularFigures()];
