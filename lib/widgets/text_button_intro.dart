import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class TextButtonIntro extends StatelessWidget {
  const TextButtonIntro({Key? key, required this.func, required this.text})
      : super(key: key);
  final VoidCallback func;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: func,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: ETextStyle.metropolis(),
            ),
            const ImageIcon(
              AssetImage("assets/images/icons/arrow_right.png"),
              color: Color(0xffdb3325),
            )
          ],
        ));
  }
}
