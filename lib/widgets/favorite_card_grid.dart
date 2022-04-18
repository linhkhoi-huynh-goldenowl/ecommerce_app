import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cubit/favorite/favorite_cubit.dart';
import '../modules/models/favorite_product.dart';
import '../utils/services/navigator_services.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(
                      NavigationService.navigatorKey.currentContext ?? context)
                  .pushNamed(Routes.productDetailsScreen,
                      arguments: favoriteProduct.productItem);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageProductWidget(
                    imagePath: favoriteProduct.productItem.images[0],
                    width: 162,
                    height: 200,
                    radius: 20),
                const SizedBox(
                  height: 5,
                ),
                ReviewStarWidget(
                    reviewStars: favoriteProduct.productItem.reviewStars,
                    numberReviews: favoriteProduct.productItem.numberReviews,
                    size: 13),
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
                    color: favoriteProduct.productItem.colors[0].color,
                    size: favoriteProduct.size),
                const SizedBox(
                  height: 3,
                ),
                PriceText(
                  salePercent: favoriteProduct.productItem.salePercent,
                  price: favoriteProduct.productItem.colors[0].sizes[0].price,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )
              ],
            ),
          ),
          favoriteProduct.productItem.salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title:
                          '-${favoriteProduct.productItem.salePercent?.toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (favoriteProduct.productItem.createdDate.month ==
                      DateTime.now().month &&
                  favoriteProduct.productItem.createdDate.year ==
                      DateTime.now().year)
              ? Positioned(
                  top: favoriteProduct.productItem.salePercent == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
              top: 0,
              right: -4,
              child: IconButton(
                splashRadius: 15,
                onPressed: () {
                  context.read<FavoriteCubit>().removeFavorite(favoriteProduct);
                },
                icon: const ImageIcon(
                    AssetImage("assets/images/icons/delete.png"),
                    size: 14),
              )),
          Positioned(
              top: 170,
              right: 0,
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
