import 'package:e_commerce_shop_app/modules/cubit/address/address_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/creditCard/credit_card_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/review/review_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/size_cloth.dart';
import 'package:e_commerce_shop_app/widgets/popup_choose_size.dart';
import 'package:e_commerce_shop_app/widgets/popup_countries.dart';
import 'package:e_commerce_shop_app/widgets/popup_credit.dart';
import 'package:e_commerce_shop_app/widgets/popup_promo.dart';
import 'package:e_commerce_shop_app/widgets/popup_review.dart';
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
          return BlocProvider.value(
              value: BlocProvider.of<ProductDetailCubit>(contextParent),
              child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                  buildWhen: (previous, current) =>
                      previous.color != current.color ||
                      previous.size != current.size ||
                      previous.sizeStatus != current.sizeStatus,
                  builder: (context, state) {
                    return PopupChooseSize(
                        listSize: listSize,
                        stateSize: state.size,
                        selectStatus: state.sizeStatus,
                        chooseSize:
                            context.read<ProductDetailCubit>().chooseSize,
                        func: () {
                          if (state.size != "") {
                            context.read<CartCubit>().addToCart(CartModel(
                                productItem: product,
                                size: state.size,
                                color: state.color,
                                quantity: 1));
                            Navigator.pop(context);
                          } else {
                            context
                                .read<ProductDetailCubit>()
                                .setUnselectSize();
                          }
                        });
                  }));
        });
  }

  static void showModalFavorite(
      BuildContext context, ProductItem product, List<SizeCloth> listSize) {
    showModalBottomSheet<void>(
        constraints:
            const BoxConstraints(maxHeight: 375, minWidth: double.infinity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        context: context,
        builder: (_) {
          return BlocProvider<ProductDetailCubit>(
              create: (BuildContext context) =>
                  ProductDetailCubit(category: product.categoryName),
              child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                  buildWhen: (previous, current) =>
                      previous.size != current.size ||
                      previous.sizeStatus != current.sizeStatus,
                  builder: (context, state) {
                    return PopupChooseSize(
                        listSize: listSize,
                        stateSize: state.size,
                        selectStatus: state.sizeStatus,
                        chooseSize:
                            context.read<ProductDetailCubit>().chooseSize,
                        func: () {
                          if (state.size != "") {
                            context.read<FavoriteCubit>().addFavorite(
                                FavoriteProduct(
                                    productItem: product, size: state.size));
                            Navigator.pop(context);
                          } else {
                            context
                                .read<ProductDetailCubit>()
                                .setUnselectSize();
                          }
                        });
                  }));
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
              BlocProvider<PromoCubit>(
                  create: (BuildContext context) => PromoCubit())
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
          return BlocProvider.value(
              value: BlocProvider.of<AddressCubit>(contextParent),
              child: const PopupCountries());
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