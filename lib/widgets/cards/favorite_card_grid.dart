import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/price_text.dart';
import 'package:e_commerce_shop_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/cubit/favorite/favorite_cubit.dart';
import '../../modules/models/favorite_product.dart';
import '../../utils/services/navigator_services.dart';
import '../buttons/button_circle.dart';
import '../chip_label.dart';
import '../color_size_widget.dart';
import '../image_product_widget.dart';

class FavoriteCardGrid extends StatelessWidget {
  const FavoriteCardGrid({Key? key, required this.favoriteProduct})
      : super(key: key);
  final FavoriteProduct favoriteProduct;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162,
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
                      arguments: {'product': favoriteProduct.productItem});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageProductWidget(
                    isGrid: true,
                    imagePath: favoriteProduct.productItem.images[0],
                    width: double.maxFinite,
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
          (favoriteProduct.productItem.createdDate.toDate().month ==
                      DateTime.now().month &&
                  favoriteProduct.productItem.createdDate.toDate().year ==
                      DateTime.now().year &&
                  favoriteProduct.productItem.createdDate.toDate().day <=
                      DateTime.now().day)
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
            child: BlocConsumer<CartCubit, CartState>(
              listenWhen: (previous, current) =>
                  previous.addStatus != current.addStatus,
              listener: (context, state) {
                if (state.addStatus == AddCartStatus.failure) {
                  AppSnackBar.showSnackBar(context, state.errMessage);
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, stateCart) {
                return ButtonCircle(
                    func: context
                            .read<CartCubit>()
                            .checkContainInFavorite(favoriteProduct)
                        ? () {}
                        : () {
                            context
                                .read<CartCubit>()
                                .addFavoriteToCart(favoriteProduct);
                          },
                    iconPath: "assets/images/icons/bag_favorite.png",
                    iconSize: 17,
                    iconColor: const Color(0xffF9F9F9),
                    fillColor: context
                            .read<CartCubit>()
                            .checkContainInFavorite(favoriteProduct)
                        ? const Color(0xffDB3022)
                        : const Color(0xff9B9B9B),
                    padding: 12);
              },
            ),
          )
        ],
      ),
    );
  }
}
