import 'package:flutter/material.dart';

class CustomPalette {
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFECEFF1),
      100: Color(0xFFCFD8DC),
      200: Color(0xFFB0BEC5),
      300: Color(0xFF90A4AE),
      400: Color(0xFF78909C),
      500: Color(_primaryValue),
      600: Color(0xFF546E7A),
      700: Color(0xFF455A64),
      800: Color(0xFFFF8F00),
      900: Color(0xFF263238),
    },
  );
  static const int _primaryValue = 0xFF607D8B;
}

