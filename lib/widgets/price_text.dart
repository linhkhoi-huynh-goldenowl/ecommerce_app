import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText({Key? key, this.priceSale, required this.price})
      : super(key: key);
  final double? priceSale;
  final double price;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          priceSale != null
              ? TextSpan(
                  text: '${price.toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(
                      fontSize: 14,
                      color: const Color(0xff9B9B9B),
                      decoration: TextDecoration.lineThrough))
              : TextSpan(
                  text: '${price.toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(fontSize: 14)),
          priceSale != null
              ? TextSpan(
                  text: ' ${priceSale!.toStringAsFixed(0)}\$',
                  style: ETextStyle.metropolis(
                      color: const Color(0xffDB3022), fontSize: 14))
              : const TextSpan(
                  text: '',
                ),
        ],
      ),
    );
  }
}
