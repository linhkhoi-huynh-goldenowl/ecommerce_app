import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/widgets/price_text.dart';
import 'package:ecommerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

import 'button_circle.dart';
import 'chip_label.dart';
import 'image_product_widget.dart';

class MainProductCard extends StatelessWidget {
  const MainProductCard(
      {Key? key,
      required this.title,
      required this.brandName,
      required this.image,
      required this.price,
      this.priceSale,
      this.salePercent,
      required this.isNew,
      required this.numberReviews,
      required this.reviewStars})
      : super(key: key);
  final String title;
  final String brandName;
  final String image;
  final double price;
  final double? priceSale;
  final double? salePercent;
  final bool isNew;
  final int numberReviews;
  final int reviewStars;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageProductWidget(
                    imagePath: image,
                    width: double.maxFinite,
                    height: 200,
                    radius: 20),
                const SizedBox(
                  height: 5,
                ),
                ReviewStarWidget(
                    reviewStars: reviewStars, numberReviews: numberReviews),
                const SizedBox(
                  height: 5,
                ),
                Text(brandName,
                    style: ETextStyle.metropolis(
                        fontSize: 11, color: Color(0xff9B9B9B))),
                const SizedBox(
                  height: 5,
                ),
                Text(title,
                    style: ETextStyle.metropolis(weight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                PriceText(priceSale: priceSale, price: price)
              ],
            ),
          ),
          salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title: '-${salePercent!.toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          isNew
              ? const Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
            top: 170,
            right: -23,
            child: ButtonCircle(
                func: () {},
                iconPath: "assets/images/icons/heart.png",
                iconSize: 16,
                iconColor: const Color(0xffDADADA),
                fillColor: Colors.white,
                padding: 12),
          )
        ],
      ),
    );
  }
}
