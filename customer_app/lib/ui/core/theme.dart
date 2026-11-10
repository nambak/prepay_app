import 'package:flutter/material.dart';

import 'icons.dart';
import 'tokens.dart';

final appTheme = ThemeData(
  fontFamily: 'Pretendard',
  scaffoldBackgroundColor: AppColors.bgPage,
  colorScheme: const ColorScheme.light(
    primary: AppColors.textPrimary,
    onPrimary: AppColors.surface,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.danger,
  ),
  textTheme: const TextTheme(
    bodyLarge: AppText.input,
    bodyMedium: AppText.body,
    bodySmall: AppText.secondary,
  ),
  splashFactory: NoSplash.splashFactory,
  // 바텀시트: 위 모서리 28, 손잡이 40x4. 손잡이 색은 시안의 #D1D6DB(꺼진 토글과 같은 값).
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surface,
    modalBarrierColor: AppColors.dim,
    showDragHandle: true,
    dragHandleColor: AppColors.toggleOff,
    dragHandleSize: Size(40, 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
    ),
  ),
  // 모든 AppBar의 기본 뒤로 버튼을 시안의 꺾쇠(SVG)로 바꾼다. 화면마다 leading을 따로 넣지 않는다.
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) => const SvgIcon(
      AppIcons.back,
      color: AppColors.textPrimary,
      strokeWidth: 2,
    ),
  ),
);
