import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
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
    return BlocConsumer<CartCubit, CartState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CartStatus.failure) {
            AppSnackBar.showSnackBar(context, state.errMessage);
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Scaffold(
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      shadowColor: Colors.white,
                      elevation: 5,
                      backgroundColor: const Color(0xffF9F9F9),
                      expandedHeight: 110.0,
                      pinned: true,
                      stretch: true,
                      automaticallyImplyLeading: false,
                      flexibleSpace: BlocBuilder<CartCubit, CartState>(
                          buildWhen: (previous, current) =>
                              previous.isSearch != current.isSearch,
                          builder: (context, state) {
                            return _flexibleSpaceBar(
                                context, state.isSearch, state.searchInput);
                          }),
                      actions: [
                        BlocBuilder<CartCubit, CartState>(
                            buildWhen: (previous, current) =>
                                previous.isSearch != current.isSearch,
                            builder: (context, state) {
                              return _findButton(context);
                            })
                      ]),
                ];
              },
              body: BlocBuilder<CartCubit, CartState>(
                  buildWhen: (previous, current) =>
                      previous.carts != current.carts,
                  builder: (context, state) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return CartCardWidget(
                            cartModel: state.carts[index],
                            addToCart: context.read<CartCubit>().addToCart,
                            removeByOneCart:
                                context.read<CartCubit>().removeCartByOne,
                            addToFavorite:
                                context.read<FavoriteCubit>().addFavorite,
                            removeCart: context.read<CartCubit>().removeCart,
                          );
                        },
                        itemCount: state.carts.length);
                  }),
            ),
            bottomNavigationBar: BottomAppBar(
                elevation: 0,
                color: const Color(0xffF9F9F9),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PromoCodeField(
                            clearCode: () {
                              context.read<CartCubit>().clearCodePromo();
                            },
                            atCartScreen: true,
                            key: ValueKey(state.code),
                            isValid: true,
                            readOnly: true,
                            initValue: state.code,
                            onTap: () {
                              BottomSheetApp.showModalPromo(
                                  context, state.code);
                            }),
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
                            state.status == CartStatus.loading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    "${state.totalPrice.toStringAsFixed(0)}\$",
                                    style: ETextStyle.metropolis(
                                      weight: FontWeight.w600,
                                      color: const Color(0xff222222),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        ButtonIntro(
                            func: () {
                              if (state.carts.isNotEmpty) {
                                Navigator.of(NavigationService
                                            .navigatorKey.currentContext ??
                                        context)
                                    .pushNamed(Routes.checkoutScreen,
                                        arguments: {
                                      'carts': state.carts,
                                      'promoId': state.code,
                                      'totalPrice': state.totalPrice,
                                      'contextBag': context
                                    });
                              } else {
                                AppSnackBar.showSnackBar(
                                    context, "Please add product to cart");
                              }
                            },
                            title: "CHECK OUT")
                      ],
                    ))),
          );
        });
  }
}

Widget _findButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<CartCubit>(context).cartOpenSearchBarEvent();
      },
      icon: Image.asset('assets/images/icons/find.png'));
}

Widget _flexibleSpaceBar(
    BuildContext context, bool isSearch, String searchInput) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    var top = constraints.biggest.height;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
          left: top < MediaQuery.of(context).size.height * 0.13 ? 0 : 16,
          bottom: top < MediaQuery.of(context).size.height * 0.13 ? 15 : 0),
      centerTitle:
          top < MediaQuery.of(context).size.height * 0.13 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Text(
            "My Bag",
            textAlign: TextAlign.start,
            style: ETextStyle.metropolis(
                weight: top < MediaQuery.of(context).size.height * 0.13
                    ? FontWeight.w600
                    : FontWeight.w700,
                fontSize:
                    top < MediaQuery.of(context).size.height * 0.13 ? 22 : 27),
          )),
    );
  });
}
