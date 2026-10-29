import 'package:flutter/material.dart';

abstract final class AppColors {
  static const textPrimary = Color(0xFF191F28);
  static const textSecondary = Color(0xFF4E5968);
  static const textMuted = Color(0xFF636D7A);
  static const iconMuted = Color(0xFF8B95A1);
  static const danger = Color(0xFFD42A2A);

  static const bgPage = Color(0xFFF2F4F6);
  static const surface = Color(0xFFFFFFFF);
  static const bgField = Color(0xFFF2F4F6);
  static const dim = Color(0x80191F28);

  static const border = Color(0xFFE5E8EB);
  static const borderInner = Color(0xFFF2F4F6);

  static const brandRed = Color(0xFFEE3E3D);
  static const buttonRed = Color(0xFFDA2F2E);

  static const discountBg = Color(0xFFFFF0F0);
  static const discountText = Color(0xFFC42726);

  static const cashCharge = Color(0xFFEE3E3D);
  static const cashShared = Color(0xFF6E5DA8);
  static const cashSharedBg = Color(0xFFF1EFFA);
  static const cashSharedText = Color(0xFF5A4A95);
  static const cashService = Color(0xFFF2A14A);
  static const cashServiceBg = Color(0xFFFFF4E6);
  static const cashServiceText = Color(0xFFA35A00);

  static const successBg = Color(0xFFECF7EF);
  static const successText = Color(0xFF2C7445);
  static const toggleOn = Color(0xFF191F28);
  static const toggleOff = Color(0xFFD1D6DB);
}

// 업종 썸네일 색 (배경, 아이콘)
enum AppTone {
  a(Color(0xFFFFF1E8), Color(0xFFA34B12)),
  b(Color(0xFFEEF2FF), Color(0xFF3A55B0)),
  c(Color(0xFFECF7EF), Color(0xFF2C7445)),
  d(Color(0xFFF3EFFC), Color(0xFF5E46A6));

  const AppTone(this.bg, this.fg);

  final Color bg;
  final Color fg;
}

abstract final class AppText {
  static const balance = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  static const section = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  static const cardTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );
  static const input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // 시안에서 많이 쓰지만 tokens.json 에는 아직 없는 크기예요.
  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const secondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
  static const badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );
}

abstract final class AppRadius {
  static const cardLg = 24.0;
  static const card = 20.0;
  static const cardSm = 16.0;
  static const field = 14.0;
  static const button = 16.0;
  static const buttonSm = 14.0;
  static const chip = 18.0;
  static const badge = 6.0;
  static const sheet = 28.0;
}

abstract final class AppSpace {
  static const gutter = 20.0;
  static const cardMargin = 16.0;
}

abstract final class AppSize {
  static const touchTarget = 44.0;
  static const button = 56.0;
  static const buttonSm = 48.0;
  static const field = 52.0;
  static const chip = 36.0;
  static const appBar = 56.0;
}
