import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ButtonChooseSize extends StatelessWidget {
  const ButtonChooseSize(
      {Key? key,
      required this.func,
      required this.title,
      required this.chooseSize,
      required this.isInStock})
      : super(key: key);
  final VoidCallback func;
  final String title;
  final String chooseSize;
  final bool isInStock;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        onPressed: isInStock ? func : () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: chooseSize == title ? const Color(0xff222222) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: isInStock ? const Color(0xff9B9B9B) : Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(isInStock ? title : "Out stock",
            style: ETextStyle.metropolis(
                fontSize: 14,
                color: isInStock
                    ? (chooseSize == title
                        ? Colors.white
                        : const Color(0xff222222))
                    : Colors.red)),
      ),
    );
  }
}
