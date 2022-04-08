import 'package:e_commerce_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
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
            appBar: PreferredSize(
                preferredSize:
                    const Size.fromHeight(140.0), // here the desired height
                child: AppBar(
                  automaticallyImplyLeading: false,
                  actions: [_findButton()],
                  flexibleSpace: _flexibleSpaceBar(),
                  elevation: 0,
                  backgroundColor: const Color(0xffF9F9F9),
                )),
            body: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return CartCardWidget(
                    cartModel: state.carts[index],
                    addToCart: context.read<CartCubit>().addToCart,
                    removeByOneCart: context.read<CartCubit>().removeCartByOne,
                    addToFavorite: context.read<FavoriteCubit>().addFavorite,
                    removeCart: context.read<CartCubit>().removeCart,
                  );
                },
                itemCount: state.carts.length),
            bottomNavigationBar: BottomAppBar(
                elevation: 0,
                color: const Color(0xffF9F9F9),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PromoCodeField(),
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
                            Text(
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
  return FlexibleSpaceBar(
    titlePadding: const EdgeInsets.only(left: 16, bottom: 24),
    title: Text(
      "My Bag",
      style: ETextStyle.metropolis(fontSize: 34, weight: FontWeight.w700),
    ),
  );
}
