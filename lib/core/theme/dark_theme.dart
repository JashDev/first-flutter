import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'text_styles.dart';

final ThemeData g66DarkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.background,
      onPrimary: AppColors.onPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.headline1,
      bodyLarge: AppTextStyles.bodyText1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: AppColors.primary,
            disabledForegroundColor: AppColors.disabledColor)),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.disabledColor,
      ),
    ));
