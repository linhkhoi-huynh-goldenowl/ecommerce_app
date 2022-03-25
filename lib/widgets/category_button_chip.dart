import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class CategoryButtonChip extends StatelessWidget {
  const CategoryButtonChip({Key? key, required this.func, required this.title})
      : super(key: key);
  final VoidCallback func;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          primary: const Color(0xff222222),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(title,
            style: ETextStyle.metropolis(fontSize: 14, color: Colors.white)),
      ),
    );
  }
}
