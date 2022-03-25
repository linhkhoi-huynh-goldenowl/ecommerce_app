import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/widgets/button_add_favorite.dart';
import 'package:e_commerce_app/widgets/chip_label.dart';
import 'package:e_commerce_app/widgets/image_product_widget.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

class ShopProductCard extends StatelessWidget {
  const ShopProductCard({Key? key, required this.productItem})
      : super(key: key);
  final ProductItem productItem;

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
                          imagePath: productItem.image,
                          width: 104,
                          height: 104,
                          radius: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productItem.title,
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            productItem.brandName,
                            style: ETextStyle.metropolis(
                                fontSize: 11, color: const Color(0xff9B9B9B)),
                          ),
                          ReviewStarWidget(
                              reviewStars: productItem.reviewStars,
                              numberReviews: productItem.numberReviews),
                          PriceText(
                              priceSale: productItem.priceSale,
                              price: productItem.price)
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
          productItem.priceSale != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title:
                          '-${((1 - (productItem.priceSale! / productItem.price)) * 100).toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (productItem.createdDate.month == DateTime.now().month &&
                  productItem.createdDate.year == DateTime.now().year)
              ? Positioned(
                  top: productItem.priceSale == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
              bottom: 5,
              right: -23,
              child: ButtonAddFavorite(product: productItem))
        ],
      ),
    );
  }
}
