import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return FlexThemeData.light(
      scheme: FlexScheme.indigo,
      useMaterial3: true,
      fontFamily: 'Amiri',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
