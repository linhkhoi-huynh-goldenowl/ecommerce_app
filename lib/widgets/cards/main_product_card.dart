import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/utils/services/navigator_services.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_circle.dart';
import 'package:e_commerce_shop_app/widgets/price_text.dart';
import 'package:e_commerce_shop_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';

import '../chip_label.dart';
import '../image_product_widget.dart';

class MainProductCard extends StatelessWidget {
  const MainProductCard(
      {Key? key,
      required this.product,
      required this.isFavorite,
      required this.func})
      : super(key: key);
  final ProductItem product;
  final bool isFavorite;
  final VoidCallback func;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      width: 162,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(
                      NavigationService.navigatorKey.currentContext ?? context)
                  .pushNamed(Routes.productDetailsScreen,
                      arguments: {'product': product});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageProductWidget(
                    imagePath: product.images[0],
                    isGrid: true,
                    width: double.maxFinite,
                    height: 200,
                    radius: 20),
                const SizedBox(
                  height: 5,
                ),
                ReviewStarWidget(
                    reviewStars: product.reviewStars,
                    numberReviews: product.numberReviews,
                    size: 13),
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
                PriceText(
                  salePercent: product.salePercent,
                  price: product.colors[0].sizes[0].price,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
          ),
          product.salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title: '-${product.salePercent?.toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (product.createdDate.toDate().month == DateTime.now().month &&
                  product.createdDate.toDate().year == DateTime.now().year &&
                  product.createdDate.toDate().day <= DateTime.now().day)
              ? Positioned(
                  top: product.salePercent == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
              top: 170,
              right: 0,
              child: SizedBox(
                child: ButtonCircle(
                    func: func,
                    iconPath: "assets/images/icons/heart.png",
                    iconSize: 16,
                    iconColor: const Color(0xffDADADA),
                    fillColor:
                        isFavorite ? const Color(0xffDB3022) : Colors.white,
                    padding: 12),
              ))
        ],
      ),
    );
  }
}
