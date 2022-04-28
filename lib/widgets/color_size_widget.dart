import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class ColorSizeWidget extends StatelessWidget {
  const ColorSizeWidget({Key? key, required this.color, required this.size})
      : super(key: key);
  final String color;
  final String size;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: 'Color: ',
              style: ETextStyle.metropolis(
                fontSize: 11,
                color: const Color(0xff9B9B9B),
              )),
          TextSpan(
              text: color,
              style: ETextStyle.metropolis(
                  color: const Color(0xff222222), fontSize: 11)),
          const WidgetSpan(
              child: SizedBox(
            width: 8,
          )),
          TextSpan(
              text: 'Size: ',
              style: ETextStyle.metropolis(
                fontSize: 11,
                color: const Color(0xff9B9B9B),
              )),
          TextSpan(
              text: size,
              style: ETextStyle.metropolis(
                  color: const Color(0xff222222), fontSize: 11)),
        ],
      ),
    );
  }
}
