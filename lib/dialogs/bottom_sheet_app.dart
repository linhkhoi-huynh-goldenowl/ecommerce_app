import 'package:e_commerce_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/modules/cubit/product_detail/product_detail_cubit.dart';
import 'package:e_commerce_app/modules/cubit/review/review_cubit.dart';
import 'package:e_commerce_app/modules/models/cart_model.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';
import 'package:e_commerce_app/widgets/popup_choose_size.dart';
import 'package:e_commerce_app/widgets/popup_review.dart';
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
              padding: MediaQuery.of(context).viewInsets,
              child: PopupReview(productId: productId),
            ),
          );
        });
  }
}
