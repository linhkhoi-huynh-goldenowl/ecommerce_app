import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/widgets/button_circle.dart';
import 'package:e_commerce_app/widgets/chip_label.dart';
import 'package:e_commerce_app/widgets/color_size_widget.dart';
import 'package:e_commerce_app/widgets/image_product_widget.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                onTap: () {},
                child: Container(
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ImageProductWidget(
                          imagePath: favoriteProduct.productItem.image,
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
                              color: favoriteProduct.productItem.color,
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
                                      .productItem.sizes[0].price),
                              const SizedBox(
                                width: 55,
                              ),
                              ReviewStarWidget(
                                  reviewStars:
                                      favoriteProduct.productItem.reviewStars,
                                  numberReviews: favoriteProduct
                                      .productItem.numberReviews),
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
                  context.read<FavoriteCubit>().addFavorite(FavoriteProduct(
                      favoriteProduct.productItem, favoriteProduct.size));
                },
                icon: const ImageIcon(
                    AssetImage("assets/images/icons/delete.png"),
                    size: 14),
              )),
          Positioned(
              bottom: 5,
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
