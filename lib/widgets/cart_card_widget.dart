import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/models/cart_model.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/utils/helpers/product_helpers.dart';
import 'package:e_commerce_app/widgets/button_circle.dart';
import 'package:e_commerce_app/widgets/chip_label.dart';
import 'package:e_commerce_app/widgets/color_size_widget.dart';
import 'package:e_commerce_app/widgets/image_product_widget.dart';
import 'package:e_commerce_app/widgets/price_text.dart';
import 'package:flutter/material.dart';

import '../utils/services/navigator_services.dart';

class CartCardWidget extends StatelessWidget {
  const CartCardWidget(
      {Key? key,
      required this.cartModel,
      required this.addToCart,
      required this.removeByOneCart,
      required this.removeCart,
      required this.addToFavorite})
      : super(key: key);
  final CartModel cartModel;
  final Function(CartModel) addToCart;
  final Function(CartModel) removeByOneCart;
  final Function(CartModel) removeCart;
  final Function(FavoriteProduct) addToFavorite;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(NavigationService.navigatorKey.currentContext ??
                          context)
                      .pushNamed(Routes.productDetailsScreen,
                          arguments: cartModel.productItem);
                },
                child: Container(
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ImageProductWidget(
                          isGrid: false,
                          imagePath: cartModel.productItem.images[0],
                          width: 104,
                          height: 104,
                          radius: 10),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 11,
                          ),
                          Text(cartModel.productItem.title,
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.bold)),
                          const SizedBox(
                            height: 5,
                          ),
                          ColorSizeWidget(
                              color: cartModel.color, size: cartModel.size),
                          const SizedBox(
                            height: 10,
                          ),
                          _rowAdjustQuantity(
                              cartModel, addToCart, removeByOneCart)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          cartModel.productItem.salePercent != null
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: ChipLabel(
                      title:
                          '-${cartModel.productItem.salePercent?.toStringAsFixed(0)}%',
                      backgroundColor: const Color(0xffDB3022)),
                )
              : const SizedBox(),
          (cartModel.productItem.createdDate.month == DateTime.now().month &&
                  cartModel.productItem.createdDate.year == DateTime.now().year)
              ? Positioned(
                  top: cartModel.productItem.salePercent == null ? 5 : 40,
                  left: 5,
                  child: const ChipLabel(
                      title: 'NEW', backgroundColor: Color(0xff222222)),
                )
              : const SizedBox(),
          Positioned(
              top: 12,
              right: 15,
              child: PopupMenuButton<int>(
                offset: const Offset(-20, -30),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                onSelected: (int value) {
                  if (value == 1) {
                    addToFavorite(FavoriteProduct(
                        productItem: cartModel.productItem,
                        size: cartModel.size,
                        color: cartModel.color));
                  }
                  if (value == 2) {
                    removeCart(cartModel);
                  }
                },
                child: const ImageIcon(
                    AssetImage("assets/images/icons/details.png"),
                    size: 18),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 1,
                    child: Center(
                      child: Text('Add to favorites',
                          style: ETextStyle.metropolis(fontSize: 11)),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Center(
                      child: Text(
                        'Delete from the list',
                        style: ETextStyle.metropolis(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
            bottom: 35,
            right: 16,
            child: PriceText(
              salePercent: cartModel.productItem.salePercent,
              price: ProductHelper.getPriceItem(
                  cartModel.productItem, cartModel.color, cartModel.size),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

Widget _rowAdjustQuantity(CartModel cartModel, Function(CartModel) addToCart,
    Function(CartModel) removeByOneCart) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ButtonCircle(
          func: () {
            removeByOneCart(cartModel);
          },
          iconPath: "assets/images/icons/minus.png",
          iconSize: 17,
          iconColor: const Color(0xff9B9B9B),
          fillColor: const Color(0xffFFFFFF),
          padding: 0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          cartModel.quantity.toString(),
          style: ETextStyle.metropolis(fontSize: 14),
        ),
      ),
      ButtonCircle(
          func: () {
            addToCart(cartModel);
          },
          iconPath: "assets/images/icons/plus.png",
          iconSize: 17,
          iconColor: const Color(0xff9B9B9B),
          fillColor: const Color(0xffFFFFFF),
          padding: 0)
    ],
  );
}
