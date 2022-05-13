import 'package:e_commerce_shop_app/modules/cubit/address/address_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/country/country_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/creditCard/credit_card_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/review/review_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/tag/tag_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/size_cloth.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_choose_size.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_countries.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_credit.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_promo.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_review.dart';
import 'package:e_commerce_shop_app/widgets/popups/popup_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/models/favorite_product.dart';

class BottomSheetApp {
  static void showModalCart(BuildContext contextParent, ProductItem product,
      List<SizeCloth> listSize) {
    showModalBottomSheet<void>(
        constraints:
            const BoxConstraints(maxHeight: 375, minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<ProductDetailCubit>(contextParent),
                ),
                BlocProvider<CartCubit>(
                  create: (BuildContext context) => CartCubit(),
                ),
              ],
              child: BlocListener<CartCubit, CartState>(
                listenWhen: (previous, current) =>
                    previous.addStatus != current.addStatus,
                listener: (context, state) {
                  if (state.addStatus == AddCartStatus.success) {
                    Navigator.pop(context);
                    AppSnackBar.showSnackBar(
                        contextParent, "Add cart successfully");
                  }
                },
                child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                    buildWhen: (previous, current) =>
                        previous.color != current.color ||
                        previous.size != current.size ||
                        previous.sizeStatus != current.sizeStatus,
                    builder: (context, state) {
                      return PopupChooseSize(
                          title: "ADD TO CART",
                          listSize: listSize,
                          stateSize: state.size,
                          selectStatus: state.sizeStatus,
                          chooseSize:
                              context.read<ProductDetailCubit>().chooseSize,
                          func: () {
                            if (state.size != "") {
                              context.read<CartCubit>().addToCart(CartModel(
                                  title: product.title.toLowerCase(),
                                  productItem: product,
                                  size: state.size,
                                  color: state.color,
                                  quantity: 1));
                            } else {
                              context
                                  .read<ProductDetailCubit>()
                                  .setUnselectSize();
                            }
                          });
                    }),
              ));
        });
  }

  static void showModalFavorite(BuildContext context, ProductItem product) {
    showModalBottomSheet<void>(
        constraints:
            const BoxConstraints(maxHeight: 375, minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: context,
        builder: (_) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<ProductDetailCubit>(
                  create: (BuildContext context) =>
                      ProductDetailCubit(productId: product.id!),
                ),
                BlocProvider<FavoriteCubit>(
                  create: (BuildContext context) => FavoriteCubit(),
                ),
              ],
              child: BlocListener<FavoriteCubit, FavoriteState>(
                listenWhen: (previous, current) =>
                    previous.addStatus != current.addStatus,
                listener: (context, state) {
                  if (state.addStatus == AddFavoriteStatus.success) {
                    Navigator.pop(context);
                    AppSnackBar.showSnackBar(
                        context, "Add favorite successfully");
                  }
                },
                child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                    buildWhen: (previous, current) =>
                        previous.size != current.size ||
                        previous.sizeStatus != current.sizeStatus,
                    builder: (context, state) {
                      return PopupChooseSize(
                          title: "ADD TO FAVORITES",
                          listSize: product.colors[0].sizes,
                          stateSize: state.size,
                          selectStatus: state.sizeStatus,
                          chooseSize:
                              context.read<ProductDetailCubit>().chooseSize,
                          func: () {
                            if (state.size != "") {
                              context.read<FavoriteCubit>().addFavorite(
                                  FavoriteProduct(
                                      productItem: product,
                                      size: state.size,
                                      color: product.colors[0].color));
                              context
                                  .read<ProductDetailCubit>()
                                  .checkContainFavorite();
                            } else {
                              context
                                  .read<ProductDetailCubit>()
                                  .setUnselectSize();
                            }
                          });
                    }),
              ));
        });
  }

  static void showModalFavoriteInProductDetail(BuildContext contextParent,
      ProductItem product, List<SizeCloth> listSize, String color) {
    showModalBottomSheet<void>(
        constraints:
            const BoxConstraints(maxHeight: 375, minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (_) {
          return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<ProductDetailCubit>(contextParent),
                ),
                BlocProvider<FavoriteCubit>(
                  create: (BuildContext context) => FavoriteCubit(),
                ),
              ],
              child: BlocListener<FavoriteCubit, FavoriteState>(
                listenWhen: (previous, current) =>
                    previous.addStatus != current.addStatus,
                listener: (context, state) {
                  if (state.addStatus == AddFavoriteStatus.success) {
                    context.read<ProductDetailCubit>().fetchRelatedList();
                    context.read<ProductDetailCubit>().checkContainFavorite();
                    Navigator.pop(context);
                    AppSnackBar.showSnackBar(
                        contextParent, "Add favorite successfully");
                  }
                },
                child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                    buildWhen: (previous, current) =>
                        previous.size != current.size ||
                        previous.sizeStatus != current.sizeStatus,
                    builder: (context, state) {
                      return PopupChooseSize(
                          title: "ADD TO FAVORITES",
                          listSize: listSize,
                          stateSize: state.size,
                          selectStatus: state.sizeStatus,
                          chooseSize:
                              context.read<ProductDetailCubit>().chooseSize,
                          func: () {
                            if (state.size != "") {
                              context.read<FavoriteCubit>().addFavorite(
                                  FavoriteProduct(
                                      productItem: product,
                                      size: state.size,
                                      color: color));
                              context
                                  .read<ProductDetailCubit>()
                                  .checkContainFavorite();
                            } else {
                              context
                                  .read<ProductDetailCubit>()
                                  .setUnselectSize();
                            }
                          });
                    }),
              ));
        });
  }

  static void showModalReview(BuildContext contextParent, String productId) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: BlocProvider.of<ReviewCubit>(contextParent)),
              BlocProvider.value(
                  value: BlocProvider.of<ProductDetailCubit>(contextParent))
            ],
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom * 0),
              child: PopupReview(productId: productId),
            ),
          );
        });
  }

  static void showModalTag(BuildContext contextParent, Function applyTag) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: BlocProvider.of<TagCubit>(contextParent)),
            ],
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom * 0),
              child: PopupTag(applyTag: applyTag),
            ),
          );
        });
  }

  static void showModalPromo(BuildContext contextParent, [String? code]) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: BlocProvider.of<CartCubit>(contextParent)),
              BlocProvider.value(
                  value: BlocProvider.of<PromoCubit>(contextParent))
            ],
            child: PopupPromo(
              code: code,
            ),
          );
        });
  }

  static void showModelCountries(BuildContext contextParent) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return MultiBlocProvider(providers: [
            BlocProvider<CountryCubit>(
                create: (BuildContext context) => CountryCubit()),
            BlocProvider.value(
                value: BlocProvider.of<AddressCubit>(contextParent))
          ], child: const PopupCountries());
        });
  }

  static void showModalCreditCard(BuildContext contextParent) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: contextParent,
        builder: (context) {
          return BlocProvider.value(
              value: BlocProvider.of<CreditCardCubit>(contextParent),
              child: PopupCredit());
        });
  }
}
