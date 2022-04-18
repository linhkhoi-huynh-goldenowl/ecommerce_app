import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/dialogs/bottom_sheet_app.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_app/modules/models/color_cloth.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';
import 'package:e_commerce_app/utils/helpers/product_helpers.dart';
import 'package:e_commerce_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_app/widgets/button_circle.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:e_commerce_app/widgets/carousel_product.dart';
import 'package:e_commerce_app/widgets/label_tile_list.dart';
import 'package:e_commerce_app/widgets/main_product_card.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:e_commerce_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/domain.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({required this.productItem, Key? key})
      : super(key: key);
  final ProductItem productItem;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailCubit>(
        create: (BuildContext context) =>
            ProductDetailCubit(category: productItem.categoryName),
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.color != current.color ||
                previous.size != current.size ||
                previous.relatedStatus != current.relatedStatus,
            builder: (context, state) {
              return Scaffold(
                bottomNavigationBar: BottomAppBar(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: ButtonIntro(
                            func: () {
                              if (state.color != "") {
                                BottomSheetApp.showModalCart(
                                    context,
                                    productItem,
                                    productItem
                                        .colors[ProductHelper.getIndexOfColor(
                                            state.color, productItem.colors)]
                                        .sizes);
                              } else {
                                AppSnackBar.showSnackBar(
                                    context, "Please choose color");
                              }
                            },
                            title: "ADD TO CART"))),
                appBar: AppBar(
                    backgroundColor: const Color(0xffF9F9F9),
                    centerTitle: true,
                    leading: _leadingButton(context),
                    actions: [_shareButton(context)],
                    title: Text(
                      productItem.title,
                      style: ETextStyle.metropolis(weight: FontWeight.w600),
                    )),
                body: ListView(
                  children: [
                    CarouselProductWidget(imgList: productItem.images),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dropdownSize(
                              context,
                              state.size,
                              productItem
                                  .colors[ProductHelper.getIndexOfColor(
                                      state.color, productItem.colors)]
                                  .sizes),
                          _dropdownColor(
                              context, state.color, productItem.colors),
                          _favoriteButton(
                              productItem,
                              productItem
                                  .colors[ProductHelper.getIndexOfColor(
                                      state.color, productItem.colors)]
                                  .sizes)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 7, right: 16, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productItem.brandName,
                            style: ETextStyle.metropolis(
                                fontSize: 24, weight: FontWeight.w600),
                          ),
                          PriceText(
                            price: ProductHelper.getPriceItem(
                                productItem, state.color, state.size),
                            fontSize: 24,
                            salePercent: productItem.salePercent,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        productItem.title,
                        style: ETextStyle.metropolis(
                            weight: FontWeight.w600,
                            fontSize: 11,
                            color: const Color(0xff9B9B9B)),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 16, top: 10, bottom: 6),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              Routes.productRatingScreen,
                              arguments: productItem.id),
                          child: ReviewStarWidget(
                              reviewStars: productItem.reviewStars,
                              numberReviews: productItem.numberReviews,
                              size: 16),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(productItem.description,
                          textAlign: TextAlign.justify,
                          style: ETextStyle.metropolis(
                              fontSize: 14, weight: FontWeight.w500)),
                    ),
                    LabelTileListWidget(
                      title: "Shipping info",
                      func: () {},
                      haveBorderTop: true,
                    ),
                    LabelTileListWidget(
                      title: "Support",
                      func: () {},
                      haveBorderTop: false,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 24, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "You can also like this",
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.w600),
                            ),
                            Text(
                              "${state.relatedList.length} items",
                              style: ETextStyle.metropolis(
                                  color: const Color(0xff9B9B9B)),
                            )
                          ],
                        )),
                    state.relatedStatus == RelatedStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return MainProductCard(
                                    product: state.relatedList[index]);
                              },
                              itemCount: state.relatedList.length,
                            ),
                          ),
                  ],
                ),
              );
            }));
  }
}

Widget _shareButton(BuildContext context) {
  return IconButton(
      onPressed: () {},
      icon: Image.asset(
        'assets/images/icons/share.png',
      ));
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget _dropdownSize(
    BuildContext context, String size, List<SizeCloth> listSize) {
  return Container(
    width: 138,
    height: 40,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 1)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        iconSize: 14,
        items: listSize.map((e) {
          if (e.quantity > 0) {
            return DropdownMenuItem(
              value: e.size,
              child: Text(
                e.size,
                style: ETextStyle.metropolis(
                    fontSize: 14, weight: FontWeight.w600),
              ),
            );
          } else {
            return DropdownMenuItem(
              enabled: false,
              value: e.size,
              child: Text(
                "${e.size} - Out slot",
                style: ETextStyle.metropolis(
                    color: Colors.red, fontSize: 14, weight: FontWeight.w600),
              ),
            );
          }
        }).toList(),
        onChanged: (value) {
          context
              .read<ProductDetailCubit>()
              .chooseSize(value ?? listSize[0].size);
        },
        hint: Text(
          "Size",
          style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
        ),
        value: size == "" ? null : size,
      ),
    ),
  );
}

Widget _favoriteButton(ProductItem productItem, List<SizeCloth> listSize) {
  return BlocBuilder<FavoriteCubit, FavoriteState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ButtonCircle(
            func: () => BottomSheetApp.showModalFavorite(
                context, productItem, listSize),
            iconPath: "assets/images/icons/heart.png",
            iconSize: 16,
            iconColor: const Color(0xffDADADA),
            fillColor: Domain().favorite.checkContainTitle(productItem.title)
                ? const Color(0xffDB3022)
                : Colors.white,
            padding: 12);
      });
}

Widget _dropdownColor(
    BuildContext context, String color, List<ColorCloth> listColor) {
  return Container(
    width: 138,
    height: 40,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        iconSize: 14,
        items: listColor
            .map((e) => DropdownMenuItem(
                  value: e.color,
                  child: Text(
                    e.color,
                    style: ETextStyle.metropolis(
                        fontSize: 14, weight: FontWeight.w600),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          context
              .read<ProductDetailCubit>()
              .chooseColor(value ?? listColor[0].color);
        },
        hint: Text(
          "Color",
          style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
        ),
        value: color == "" ? null : color,
      ),
    ),
  );
}
