import 'package:flutter/material.dart';
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
);

