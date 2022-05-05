import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/promo/promo_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/flexible_bar_with_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
import '../../dialogs/bottom_sheet_app.dart';
import '../../utils/services/navigator_services.dart';
import '../../widgets/button_intro.dart';
import '../../widgets/cart_card_widget.dart';
import '../../widgets/promo_code_field.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromoCubit(),
      child: BlocListener<CartCubit, CartState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CartStatus.failure) {
              AppSnackBar.showSnackBar(context, state.errMessage);
            }
          },
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[_bagAppBar()];
                },
                body: _bodyBagScreen(),
              ),
            ),
            bottomNavigationBar: _bottomBar(),
          )),
    );
  }
}

Widget _bodyBagScreen() {
  return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          previous.cartsListToShow != current.cartsListToShow,
      builder: (context, state) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CartCardWidget(
                cartModel: state.cartsListToShow[index],
                addToCart: context.read<CartCubit>().addToCart,
                removeByOneCart: context.read<CartCubit>().removeCartByOne,
                addToFavorite: context.read<FavoriteCubit>().addFavorite,
                removeCart: context.read<CartCubit>().removeCart,
              );
            },
            itemCount: state.cartsListToShow.length);
      });
}

Widget _bagAppBar() {
  return SliverAppBar(
      shadowColor: Colors.white,
      elevation: 5,
      backgroundColor: const Color(0xffF9F9F9),
      expandedHeight: 110.0,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      flexibleSpace: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) =>
              previous.isSearch != current.isSearch ||
              previous.searchInput != current.searchInput,
          builder: (context, state) {
            return FlexibleBarWithSearch(
              title: "My Bag",
              isSearch: state.isSearch,
              searchInput: state.searchInput,
              func: (value) {
                BlocProvider.of<CartCubit>(context).cartSearch(value);
              },
            );
          }),
      actions: [
        BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) =>
                previous.isSearch != current.isSearch,
            builder: (context, state) {
              return _findButton(context);
            })
      ]);
}

Widget _bottomBar() {
  return BottomAppBar(
      elevation: 0,
      color: const Color(0xffF9F9F9),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) => previous.code != current.code,
                builder: (context, state) {
                  return PromoCodeField(
                      clearCode: () {
                        context.read<CartCubit>().clearCodePromo();
                      },
                      atCartScreen: true,
                      key: ValueKey(state.code),
                      isValid: true,
                      readOnly: true,
                      initValue: state.code,
                      onTap: () {
                        BottomSheetApp.showModalPromo(context, state.code);
                      });
                },
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total amount:",
                    style: ETextStyle.metropolis(
                        color: const Color(0xff9B9B9B), fontSize: 14),
                  ),
                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) =>
                        previous.totalPrice != current.totalPrice,
                    builder: (context, statePrice) {
                      return Text(
                        "${statePrice.totalPrice.toStringAsFixed(0)}\$",
                        style: ETextStyle.metropolis(
                          weight: FontWeight.w600,
                          color: const Color(0xff222222),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) =>
                    previous.carts != current.carts ||
                    previous.code != current.code ||
                    previous.totalPrice != current.totalPrice,
                builder: (context, state) {
                  return ButtonIntro(
                      func: () {
                        if (state.carts.isNotEmpty) {
                          Navigator.of(NavigationService
                                      .navigatorKey.currentContext ??
                                  context)
                              .pushNamed(Routes.checkoutScreen, arguments: {
                            'carts': state.carts,
                            'promo': state.code != ""
                                ? context
                                    .read<PromoCubit>()
                                    .getPromoById(state.code)
                                : null,
                            'totalPrice': state.totalPrice,
                            'contextBag': context
                          });
                        } else {
                          AppSnackBar.showSnackBar(
                              context, "Please add product to cart");
                        }
                      },
                      title: "CHECK OUT");
                },
              )
            ],
          )));
}

Widget _findButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<CartCubit>(context).cartOpenSearchBarEvent();
      },
      icon: Image.asset('assets/images/icons/find.png'));
}
