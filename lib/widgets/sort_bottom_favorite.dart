import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortBottomFavorite extends StatelessWidget {
  const SortBottomFavorite({Key? key, required this.state}) : super(key: key);
  final FavoriteState state;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
            primary: const Color(0xff222222),
            textStyle: ETextStyle.metropolis(fontSize: 11)),
        onPressed: () {
          showModalBottomSheet<void>(
            constraints: const BoxConstraints(maxHeight: 375),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            context: context,
            builder: (BuildContext context) {
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
                  Text("Sort by",
                      style: ETextStyle.metropolis(
                          fontSize: 18, weight: FontWeight.w600)),
                  const SizedBox(
                    height: 33,
                  ),
                  sortSelection(
                      context, ChooseSortFavorite.popular, state, "Popular"),
                  sortSelection(
                      context, ChooseSortFavorite.newest, state, "Newest"),
                  sortSelection(context, ChooseSortFavorite.review, state,
                      "Customer review"),
                  sortSelection(context, ChooseSortFavorite.priceLowest, state,
                      "Price: lowest to high"),
                  sortSelection(context, ChooseSortFavorite.priceHighest, state,
                      "Price: highest to low"),
                ],
              );
            },
          );
        },
        icon: const ImageIcon(AssetImage("assets/images/icons/range.png")),
        label: Text(
          state.sort == ChooseSortFavorite.popular
              ? "Popular"
              : state.sort == ChooseSortFavorite.newest
                  ? "Newest"
                  : state.sort == ChooseSortFavorite.review
                      ? "Customer Review"
                      : state.sort == ChooseSortFavorite.priceLowest
                          ? "Price: lowest to high"
                          : "Price: highest to low",
        ));
  }
}

Widget sortSelection(BuildContext context, ChooseSortFavorite chooseSort,
    FavoriteState state, String title) {
  return InkWell(
      onTap: () {
        context.read<FavoriteCubit>().favoriteSort(chooseSort);
        Navigator.pop(context);
      },
      child: Container(
        color: state.sort == chooseSort ? const Color(0xffDB3022) : null,
        width: double.maxFinite,
        padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 0),
        child: Text(title,
            style: ETextStyle.metropolis(
                color: state.sort == chooseSort
                    ? const Color(0xffffffff)
                    : const Color(0xff222222))),
      ));
}
