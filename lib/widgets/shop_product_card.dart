import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/widgets/button_circle.dart';
import 'package:ecommerce_app/widgets/chip_label.dart';
import 'package:ecommerce_app/widgets/image_product_widget.dart';
import 'package:ecommerce_app/widgets/price_text.dart';
import 'package:ecommerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

class ShopProductCard extends StatelessWidget {
  const ShopProductCard(
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
      width: 343,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ImageProductWidget(
                          imagePath: image,
                          width: 104,
                          height: 104,
                          radius: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            brandName,
                            style: ETextStyle.metropolis(
                                fontSize: 11, color: const Color(0xff9B9B9B)),
                          ),
                          ReviewStarWidget(
                              reviewStars: reviewStars,
                              numberReviews: numberReviews),
                          PriceText(priceSale: priceSale, price: price)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
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
              bottom: 5,
              right: -23,
              child: ButtonCircle(
                  func: () {},
                  iconPath: "assets/images/icons/heart.png",
                  iconSize: 16,
                  iconColor: const Color(0xffDADADA),
                  fillColor: Colors.white,
                  padding: 12))
        ],
      ),
    );
  }
}
