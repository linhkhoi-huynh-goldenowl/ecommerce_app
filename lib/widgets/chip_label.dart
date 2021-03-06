import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ChipLabel extends StatelessWidget {
  const ChipLabel(
      {Key? key, required this.title, required this.backgroundColor})
      : super(key: key);
  final String title;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      label: Text(title,
          style: ETextStyle.metropolis(fontSize: 11, color: Colors.white)),
    );
  }
}
