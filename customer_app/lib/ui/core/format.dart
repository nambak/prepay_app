// 숫자 세자리 마다 쉼표
import 'dart:ui';

String formatNumber(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

// 2026.11.09 14:03 (서울 시간)
// 기기 시간대와 상관없이 가게·서버 기록과 같은 시간을 보여 준다
// 한국은 서머타임이 없어서 UTC+9로 고정한다
String formatDateTime(DateTime time) {
  final t = time.toUtc().add(Duration(hours: 9));
  String two(int n) => n.toString().padLeft(2, '0');

  return '${t.year}.${two(t.month)}.${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
}

// 숫자 폭을 고르게 맞춰서 금액 자리수가 흔들리지 않게함.
const tabularFigures = [FontFeature.tabularFigures()];
