// 숫자 세자리 마다 쉼표
import 'dart:ui';

String formatNumber(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

// 한국 시각. 기기 시간대와 상관없이 가게·서버 기록과 같은 날짜·시각을 쓴다
// 한국은 서머타임이 없어서 UTC+9로 고정한다
DateTime koreaTime(DateTime time) => time.toUtc().add(Duration(hours: 9));

// 2026.11.09 14:03 (한국 시간)
String formatDateTime(DateTime time) {
  final t = koreaTime(time);
  String two(int n) => n.toString().padLeft(2, '0');

  return '${t.year}.${two(t.month)}.${two(t.day)} ${two(t.hour)}:${two(t.minute)}';
}

// 숫자 폭을 고르게 맞춰서 금액 자리수가 흔들리지 않게함.
const tabularFigures = [FontFeature.tabularFigures()];

// 11월 3일 (화) (한국 날짜)
String formatDayHeader(DateTime time) {
  final t = koreaTime(time);
  return '${t.month}월 ${t.day}일 (${'월화수목금토일'[t.weekday - 1]})';
}
