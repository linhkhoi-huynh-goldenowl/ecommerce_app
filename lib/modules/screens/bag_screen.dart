import 'package:e_commerce_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
import '../../dialogs/bottom_sheet_app.dart';
import '../../widgets/button_intro.dart';
import '../../widgets/cart_card_widget.dart';
import '../../widgets/promo_code_field.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
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
                      flexibleSpace: _flexibleSpaceBar(),
                      actions: [_findButton()]),
                ];
              },
              body: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CartCardWidget(
                      cartModel: state.carts[index],
                      addToCart: context.read<CartCubit>().addToCart,
                      removeByOneCart:
                          context.read<CartCubit>().removeCartByOne,
                      addToFavorite: context.read<FavoriteCubit>().addFavorite,
                      removeCart: context.read<CartCubit>().removeCart,
                    );
                  },
                  itemCount: state.carts.length),
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
                        ButtonIntro(func: () {}, title: "CHECK OUT")
                      ],
                    ))),
          );
        });
  }
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}

Widget _flexibleSpaceBar() {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    var top = constraints.biggest.height;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
          left: top > 71 && top < 91 ? 0 : 16,
          bottom: top > 71 && top < 91 ? 12 : 0),
      centerTitle: top > 71 && top < 91 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Text(
            "My Bag",
            textAlign: TextAlign.start,
            style: ETextStyle.metropolis(
                weight:
                    top > 71 && top < 91 ? FontWeight.w600 : FontWeight.w700,
                fontSize: top > 71 && top < 91 ? 22 : 27),
          )),
    );
  });
}
