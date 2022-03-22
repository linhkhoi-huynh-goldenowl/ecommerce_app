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
                  style: const TextStyle(
                    fontFamily: "Metropolis",
                    color: Color(0xff9B9B9B),
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              : TextSpan(
                  text: '${price.toStringAsFixed(0)}\$',
                  style: const TextStyle(
                    fontFamily: "Metropolis",
                    color: Color(0xff222222),
                  ),
                ),
          priceSale != null
              ? TextSpan(
                  text: ' ${priceSale!.toStringAsFixed(0)}\$',
                  style: const TextStyle(
                    fontFamily: "Metropolis",
                    color: Color(0xffDB3022),
                  ),
                )
              : const TextSpan(
                  text: '',
                ),
        ],
      ),
    );
  }
}
