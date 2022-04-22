import 'package:flutter/material.dart';

class ETextStyle {
  static metropolis(
      {Color color = const Color(0xff222222),
      double fontSize = 16,
      FontWeight? weight,
      TextDecoration? decoration,
      double? letterSpacing}) {
    return TextStyle(
        letterSpacing: letterSpacing,
        color: color,
        fontSize: fontSize,
        fontFamily: "Metropolis",
        fontWeight: weight,
        decoration: decoration);
  }
}
