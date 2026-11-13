import 'package:material_ui/material_ui.dart';

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

  static const pointCharge = Color(0xFFEE3E3D);
  static const pointShared = Color(0xFF6E5DA8);
  static const pointSharedBg = Color(0xFFF1EFFA);
  static const pointSharedText = Color(0xFF5A4A95);
  static const pointService = Color(0xFFF2A14A);
  static const pointServiceBg = Color(0xFFFFF4E6);
  static const pointServiceText = Color(0xFFA35A00);

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

  // 같은 크기에 굵기만 다른 글자. 화면에서 두 번 이상 쓰는 조합만 둔다.
  static final bodyMedium = body.copyWith(fontWeight: FontWeight.w500);
  static final bodyBold = body.copyWith(fontWeight: FontWeight.w700);
  static final inputMedium = input.copyWith(fontWeight: FontWeight.w500);
  static final inputBold = input.copyWith(fontWeight: FontWeight.w700);
  static final labelMedium = label.copyWith(fontWeight: FontWeight.w500);
  static final secondaryMedium = secondary.copyWith(
    fontWeight: FontWeight.w500,
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
