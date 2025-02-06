import 'package:flutter/material.dart';
import 'color_scheme.dart';

class AppTextStyles {
  static const TextStyle displayMedium = TextStyle(
    fontSize: 20,
    color: AppColors.primary,
    fontWeight: FontWeight.w500
  );
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );
}
