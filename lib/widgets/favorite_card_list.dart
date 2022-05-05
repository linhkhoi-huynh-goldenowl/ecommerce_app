import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/widgets/button_circle.dart';
import 'package:e_commerce_shop_app/widgets/chip_label.dart';
import 'package:e_commerce_shop_app/widgets/color_size_widget.dart';
import 'package:e_commerce_shop_app/widgets/image_product_widget.dart';
import 'package:e_commerce_shop_app/widgets/price_text.dart';
import 'package:e_commerce_shop_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cubit/cart/cart_cubit.dart';
import '../modules/repositories/domain.dart';
import '../utils/helpers/show_snackbar.dart';
import '../utils/services/navigator_services.dart';

class FavoriteCardList extends StatelessWidget {
  const FavoriteCardList({Key? key, required this.favoriteProduct})
      : super(key: key);
  final FavoriteProduct favoriteProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(NavigationService.navigatorKey.currentContext ??
                          context)
                      .pushNamed(Routes.productDetailsScreen, arguments: {
                    'product': favoriteProduct.productItem,
                    'contextParent': context
                  });
                },
                child: Container(
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ImageProductWidget(
                          isGrid: false,
                          imagePath: favoriteProduct.productItem.images[0],
                          width: 104,
                          height: 104,
                          radius: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            favoriteProduct.productItem.brandName,
                            style: ETextStyle.metropolis(
                                fontSize: 11, color: const Color(0xff9B9B9B)),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(favoriteProduct.productItem.title,
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          ColorSizeWidget(
                              color: favoriteProduct.color ??
                                  favoriteProduct.productItem.colors[0].color,
                              size: favoriteProduct.size),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              PriceText(
                                salePercent:
                                    favoriteProduct.productItem.salePercent,
                                price: favoriteProduct
                                    .productItem.colors[0].sizes[0].price,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                width: 55,
                              ),
                              ReviewStarWidget(
                                  reviewStars:
                                      favoriteProduct.productItem.reviewStars,
                                  numberReviews:
                                      favoriteProduct.productItem.numberReviews,
                                  size: 13),
                            ],
                          )
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
              right: 0,
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
              bottom: 5,
              right: 0,
              child: BlocListener<FavoriteCubit, FavoriteState>(
                listenWhen: (previous, current) =>
                    previous.addCartStatus != current.addCartStatus,
                listener: (context, state) {
                  if (state.addCartStatus == AddCartStatus.failure) {
                    AppSnackBar.showSnackBar(context, state.errMessage);
                  }
                },
                child: BlocBuilder<CartCubit, CartState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return ButtonCircle(
                        func: Domain()
                                .cart
                                .checkContainInFavorite(favoriteProduct)
                            ? () {}
                            : () {
                                context
                                    .read<FavoriteCubit>()
                                    .addFavoriteToCart(favoriteProduct);
                              },
                        iconPath: "assets/images/icons/bag_favorite.png",
                        iconSize: 17,
                        iconColor: const Color(0xffF9F9F9),
                        fillColor: Domain()
                                .cart
                                .checkContainInFavorite(favoriteProduct)
                            ? const Color(0xffDB3022)
                            : const Color(0xff9B9B9B),
                        padding: 12);
                  },
                ),
              ))
        ],
      ),
    );
  }
}
