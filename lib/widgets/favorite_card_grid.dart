import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

import '../modules/models/favorite_product.dart';
import 'button_circle.dart';
import 'chip_label.dart';
import 'color_size_widget.dart';
import 'image_product_widget.dart';

class FavoriteCardGrid extends StatelessWidget {
  const FavoriteCardGrid({Key? key, required this.favoriteProduct})
      : super(key: key);
  final FavoriteProduct favoriteProduct;
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
                    imagePath: favoriteProduct.productItem.image,
                    width: double.maxFinite,
                    height: 200,
                    radius: 20),
                const SizedBox(
                  height: 5,
                ),
                ReviewStarWidget(
                    reviewStars: favoriteProduct.productItem.reviewStars,
                    numberReviews: favoriteProduct.productItem.numberReviews),
                const SizedBox(
                  height: 5,
                ),
                Text(favoriteProduct.productItem.brandName,
                    style: ETextStyle.metropolis(
                        fontSize: 11, color: const Color(0xff9B9B9B))),
                const SizedBox(
                  height: 5,
                ),
                Text(favoriteProduct.productItem.title,
                    style: ETextStyle.metropolis(weight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                ColorSizeWidget(
                    color: favoriteProduct.productItem.color,
                    size: favoriteProduct.size),
                const SizedBox(
                  height: 3,
                ),
                PriceText(
                    priceSale: favoriteProduct.productItem.priceSale,
                    price: favoriteProduct.productItem.price)
              ],
            ),
          ),
          favoriteProduct.productItem.priceSale != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title:
                          '-${((1 - (favoriteProduct.productItem.priceSale! / favoriteProduct.productItem.price)) * 100).toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (favoriteProduct.productItem.createdDate.month ==
                      DateTime.now().month &&
                  favoriteProduct.productItem.createdDate.year ==
                      DateTime.now().year)
              ? Positioned(
                  top: favoriteProduct.productItem.priceSale == null ? 5 : 40,
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
                  iconPath: "assets/images/icons/bag_favorite.png",
                  iconSize: 17,
                  iconColor: const Color(0xffF9F9F9),
                  fillColor: const Color(0xffDB3022),
                  padding: 12))
        ],
      ),
    );
  }
}
