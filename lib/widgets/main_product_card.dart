import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

import 'button_circle.dart';
import 'chip_label.dart';
import 'image_product_widget.dart';

class MainProductCard extends StatelessWidget {
  const MainProductCard({Key? key, required this.product}) : super(key: key);
  final ProductItem product;
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
                    imagePath: product.image,
                    width: double.maxFinite,
                    height: 200,
                    radius: 20),
                const SizedBox(
                  height: 5,
                ),
                ReviewStarWidget(
                    reviewStars: product.reviewStars,
                    numberReviews: product.numberReviews),
                const SizedBox(
                  height: 5,
                ),
                Text(product.brandName,
                    style: ETextStyle.metropolis(
                        fontSize: 11, color: const Color(0xff9B9B9B))),
                const SizedBox(
                  height: 5,
                ),
                Text(product.title,
                    style: ETextStyle.metropolis(weight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                PriceText(priceSale: product.priceSale, price: product.price)
              ],
            ),
          ),
          product.priceSale != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title:
                          '-${((1 - (product.priceSale! / product.price)) * 100).toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (product.createdDate.month == DateTime.now().month &&
                  product.createdDate.year == DateTime.now().year)
              ? Positioned(
                  top: product.priceSale == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
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
