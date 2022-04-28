import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ButtonChooseSize extends StatelessWidget {
  const ButtonChooseSize(
      {Key? key,
      required this.func,
      required this.title,
      required this.chooseSize})
      : super(key: key);
  final VoidCallback func;
  final String title;
  final String chooseSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 100,
      child: ElevatedButton(
        onPressed: func,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: chooseSize == title ? const Color(0xff222222) : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xff9B9B9B)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(title,
            style: ETextStyle.metropolis(
                fontSize: 14,
                color: chooseSize == title
                    ? Colors.white
                    : const Color(0xff222222))),
      ),
    );
  }
}
