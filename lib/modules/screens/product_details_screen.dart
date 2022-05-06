import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/dialogs/bottom_sheet_app.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/color_cloth.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/size_cloth.dart';
import 'package:e_commerce_shop_app/utils/helpers/product_helpers.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_circle.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:e_commerce_shop_app/widgets/carousel_product.dart';
import 'package:e_commerce_shop_app/widgets/label_tile_list.dart';
import 'package:e_commerce_shop_app/widgets/cards/main_product_card.dart';
import 'package:e_commerce_shop_app/widgets/price_text.dart';
import 'package:e_commerce_shop_app/widgets/review_star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
import '../cubit/cart/cart_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(
      {required this.productItem, Key? key, required this.contextParent})
      : super(key: key);
  final ProductItem productItem;
  final BuildContext contextParent;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProductDetailCubit>(
            create: (BuildContext context) =>
                ProductDetailCubit(category: productItem.categoryName),
          ),
          BlocProvider.value(
            value: BlocProvider.of<ProductCubit>(contextParent),
          ),
          BlocProvider.value(
            value: BlocProvider.of<CartCubit>(contextParent),
          ),
          BlocProvider.value(
            value: BlocProvider.of<FavoriteCubit>(contextParent),
          ),
        ],
        child: Scaffold(
          bottomNavigationBar: _bottomBar(),
          appBar: _appBar(),
          body: ListView(
            children: [
              CarouselProductWidget(imgList: productItem.images),
              _chooseOptionBar(context),
              _showProductTitle(),
              _showProductBrandAndPrice(),
              _reviewBar(),
              _productDescription(),
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
              _showRelatedCount(),
              _showRelatedList(),
            ],
          ),
        ));
  }

  Widget _bottomBar() {
    return BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
              builder: (context, state) {
                return ButtonIntro(
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
                    title: "ADD TO CART");
              },
            )));
  }

  AppBar _appBar() {
    return AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        centerTitle: true,
        leading: const ButtonLeading(),
        actions: [_shareButton()],
        title: Text(
          productItem.title,
          style: ETextStyle.metropolis(weight: FontWeight.w600),
        ));
  }

  Widget _shareButton() {
    return IconButton(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/icons/share.png',
        ));
  }

  Widget _productDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(productItem.description,
          maxLines: 10,
          textAlign: TextAlign.justify,
          style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w500)),
    );
  }

  Widget _showRelatedList() {
    return SizedBox(
      height: 300,
      child: BlocBuilder<ProductCubit, ProductState>(
        buildWhen: (previous, current) =>
            previous.statusSale != current.statusSale,
        builder: (context, state) {
          if (state.statusSale == ProductSaleStatus.loading) {
            return const LoadingWidget();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: MainProductCard(product: state.productSaleList[index]),
                );
              },
              itemCount: state.productSaleList.length,
            );
          }
        },
      ),
    );
  }

  Widget _showProductTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        productItem.title,
        style: ETextStyle.metropolis(
            weight: FontWeight.w600,
            fontSize: 11,
            color: const Color(0xff9B9B9B)),
      ),
    );
  }

  Widget _showProductBrandAndPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 7, right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            productItem.brandName,
            style: ETextStyle.metropolis(fontSize: 24, weight: FontWeight.w600),
          ),
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (previous, current) =>
                previous.color != current.color ||
                previous.size != current.size,
            builder: (context, state) {
              return PriceText(
                price: ProductHelper.getPriceItem(
                    productItem, state.color, state.size),
                fontSize: 24,
                salePercent: productItem.salePercent,
                fontWeight: FontWeight.w600,
              );
            },
          )
        ],
      ),
    );
  }

  Widget _reviewBar() {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      buildWhen: (previous, current) =>
          previous.reviewStars != current.reviewStars ||
          previous.numReview != current.numReview,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.only(left: 16, top: 10, bottom: 6),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                  Routes.productRatingScreen,
                  arguments: {'productId': productItem.id, 'context': context}),
              child: ReviewStarWidget(
                reviewStars: state.reviewStars > 0
                    ? state.reviewStars
                    : productItem.reviewStars,
                numberReviews: state.numReview > 0
                    ? state.numReview
                    : productItem.numberReviews,
                size: 16,
              ),
            ));
      },
    );
  }

  Widget _chooseOptionBar(BuildContext contextDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
              buildWhen: (previous, current) =>
                  previous.color != current.color ||
                  previous.size != current.size ||
                  previous.sizeStatus != current.sizeStatus,
              builder: (contextDetail, state) {
                return _dropdownSize(
                    contextDetail,
                    state.size,
                    productItem
                        .colors[ProductHelper.getIndexOfColor(
                            state.color, productItem.colors)]
                        .sizes);
              }),
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (previous, current) => previous.color != current.color,
            builder: (context, state) {
              return _dropdownColor(context, state.color, productItem.colors);
            },
          ),
          BlocBuilder<ProductDetailCubit, ProductDetailState>(
            buildWhen: (previous, current) => previous.color != current.color,
            builder: (context, state) {
              return _favoriteButton(
                  productItem,
                  productItem
                      .colors[ProductHelper.getIndexOfColor(
                          state.color, productItem.colors)]
                      .sizes,
                  state.color == ""
                      ? productItem.colors[0].color
                      : state.color);
            },
          )
        ],
      ),
    );
  }

  Widget _showRelatedCount() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You can also like this",
              style: ETextStyle.metropolis(weight: FontWeight.w600),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
                  previous.productSaleList != current.productSaleList,
              builder: (context, state) {
                return Text(
                  "${state.productSaleList.length} items",
                  style: ETextStyle.metropolis(color: const Color(0xff9B9B9B)),
                );
              },
            )
          ],
        ));
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
                  "${e.size} - Out stock",
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

  Widget _favoriteButton(
      ProductItem productItem, List<SizeCloth> listSize, String color) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ButtonCircle(
              func: () => BottomSheetApp.showModalFavorite(
                  context, productItem, listSize, color),
              iconPath: "assets/images/icons/heart.png",
              iconSize: 16,
              iconColor: const Color(0xffDADADA),
              fillColor:
                  context.read<FavoriteCubit>().checkContainId(productItem.id!)
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
}
