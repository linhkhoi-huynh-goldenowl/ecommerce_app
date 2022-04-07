import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText(
      {Key? key,
      this.salePercent,
      required this.price,
      required this.fontSize,
      required this.fontWeight})
      : super(key: key);
  final double? salePercent;
  final double price;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          salePercent != null
              ? TextSpan(
                  text: '${price.toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(
                      fontSize: fontSize,
                      color: const Color(0xff9B9B9B),
                      decoration: TextDecoration.lineThrough,
                      weight: fontWeight))
              : TextSpan(
                  text: '${price.toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(
                      fontSize: fontSize, weight: fontWeight)),
          salePercent != null
              ? TextSpan(
                  text:
                      ' ${(price - (price * salePercent! / 100)).toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(
                      color: const Color(0xffDB3022),
                      fontSize: fontSize,
                      weight: fontWeight))
              : const TextSpan(
                  text: '',
                ),
        ],
      ),
    );
  }
}
