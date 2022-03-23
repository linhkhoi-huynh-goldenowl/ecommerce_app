import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ButtonIntro extends StatelessWidget {
  const ButtonIntro({
    Key? key,
    required this.func,
    required this.title,
  }) : super(key: key);
  final VoidCallback func;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          primary: const Color(0xffDB3022),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 15.0,
        ),
        onPressed: func,
        child: Text(title,
            style: ETextStyle.metropolis(
                fontSize: 18, color: const Color(0xfffbedec))),
      ),
    );
  }
}
