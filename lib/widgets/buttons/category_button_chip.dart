import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class CategoryButtonChip extends StatelessWidget {
  const CategoryButtonChip(
      {Key? key,
      required this.func,
      required this.title,
      required this.chooseCategory})
      : super(key: key);
  final VoidCallback func;
  final String chooseCategory;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          primary: chooseCategory == title
              ? const Color(0xffffffff)
              : const Color(0xff222222),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(title,
            style: ETextStyle.metropolis(
                fontSize: 14,
                color: chooseCategory == title ? Colors.black : Colors.white)),
      ),
    );
  }
}
