import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';

class SortBottomWidget extends StatelessWidget {
  const SortBottomWidget(
      {Key? key, required this.chooseSort, required this.applyChoose})
      : super(key: key);
  final ChooseSort chooseSort;
  final Function(ChooseSort) applyChoose;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
            primary: const Color(0xff222222),
            textStyle: ETextStyle.metropolis(fontSize: 11)),
        onPressed: () {
          _showModal(context, chooseSort, applyChoose);
        },
        icon: const ImageIcon(AssetImage("assets/images/icons/range.png")),
        label: Text(
          chooseSort == ChooseSort.popular
              ? "Popular"
              : chooseSort == ChooseSort.newest
                  ? "Newest"
                  : chooseSort == ChooseSort.review
                      ? "Customer Review"
                      : chooseSort == ChooseSort.priceLowest
                          ? "Price: lowest to high"
                          : "Price: highest to low",
        ));
  }
}

void _showModal(BuildContext context, ChooseSort stateSort,
    Function(ChooseSort) applyChoose) {
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
              style:
                  ETextStyle.metropolis(fontSize: 18, weight: FontWeight.w600)),
          const SizedBox(
            height: 33,
          ),
          _sortSelection(
              context, ChooseSort.popular, stateSort, "Popular", applyChoose),
          _sortSelection(
              context, ChooseSort.newest, stateSort, "Newest", applyChoose),
          _sortSelection(context, ChooseSort.review, stateSort,
              "Customer review", applyChoose),
          _sortSelection(context, ChooseSort.priceLowest, stateSort,
              "Price: lowest to high", applyChoose),
          _sortSelection(context, ChooseSort.priceHighest, stateSort,
              "Price: highest to low", applyChoose),
        ],
      );
    },
  );
}

Widget _sortSelection(BuildContext context, ChooseSort chooseSort,
    ChooseSort stateSort, String title, Function(ChooseSort) applyChoose) {
  return InkWell(
    onTap: () {
      applyChoose(chooseSort);
      Navigator.pop(context);
    },
    child: Container(
      color: stateSort == chooseSort ? const Color(0xffDB3022) : null,
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 0),
      child: Text(title,
          style: ETextStyle.metropolis(
              color: stateSort == chooseSort
                  ? const Color(0xffffffff)
                  : const Color(0xff222222))),
    ),
  );
}
