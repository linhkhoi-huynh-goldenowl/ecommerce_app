import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/favorite_repository.dart';
import 'package:e_commerce_app/widgets/button_choose_size.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'button_circle.dart';

class ButtonAddFavorite extends StatelessWidget {
  const ButtonAddFavorite({Key? key, required this.product}) : super(key: key);
  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>(
        create: (BuildContext context) =>
            FavoriteCubit(favoriteRepository: FavoriteRepository()),
        child: _buildBody(context, product));
  }
}

Widget _buildBody(BuildContext context, ProductItem product) {
  return ButtonCircle(
      func: () {
        showModalBottomSheet<void>(
          constraints:
              const BoxConstraints(maxHeight: 375, minWidth: double.infinity),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          context: context,
          builder: (BuildContext context) {
            return BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),
                  Image.asset(
                    "assets/images/icons/rectangle.png",
                    scale: 3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Select Size",
                    style: TextStyle(
                        color: Color(0xff222222),
                        fontFamily: "Metropolis",
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Wrap(
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      ButtonChooseSize(
                          func: () {
                            context.read<FavoriteCubit>().chooseSize("XS");
                          },
                          title: "XS",
                          chooseSize: state.size),
                      ButtonChooseSize(
                          func: () {
                            context.read<FavoriteCubit>().chooseSize("S");
                          },
                          title: "S",
                          chooseSize: state.size),
                      ButtonChooseSize(
                          func: () {
                            context.read<FavoriteCubit>().chooseSize("M");
                          },
                          title: "M",
                          chooseSize: state.size),
                      ButtonChooseSize(
                          func: () {
                            context.read<FavoriteCubit>().chooseSize("L");
                          },
                          title: "L",
                          chooseSize: state.size),
                      ButtonChooseSize(
                          func: () {
                            context.read<FavoriteCubit>().chooseSize("XL");
                          },
                          title: "XL",
                          chooseSize: state.size),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                      onTap: () {},
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: Color(0xff9B9B9B), width: 0.4))),
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 16, top: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Size Info",
                                style: ETextStyle.metropolis(),
                              ),
                              const ImageIcon(
                                AssetImage(
                                    "assets/images/icons/next_right.png"),
                                size: 8,
                              )
                            ],
                          ))),
                  const SizedBox(
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ButtonIntro(
                        func: () {
                          context.read<FavoriteCubit>().addFavorite(
                              FavoriteProduct(product, state.size));
                          Navigator.pop(context);
                        },
                        title: "ADD TO FAVORITE"),
                  )
                ],
              );
            });
          },
        );
      },
      iconPath: "assets/images/icons/heart.png",
      iconSize: 16,
      iconColor: const Color(0xffDADADA),
      fillColor: Colors.white,
      padding: 12);
}
