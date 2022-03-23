import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sort_button_sheet.dart';
import 'category_button_chip.dart';

class FilterProductBar extends StatelessWidget {
  FilterProductBar({Key? key, required this.state}) : super(key: key);
  final ProductState state;

  final titles = <String>[
    "Tops",
    "Shirts & Blouses",
    "Cardigans & Sweaters",
    "Knitwear",
    "Blazers",
    "Outerwear",
    "Pants",
    "Jeans",
    "Shorts",
    "Skirts",
    "Dresses"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF9F9F9),
      height: 500,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: titles.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return CategoryButtonChip(
                    func: () {
                      BlocProvider.of<ProductCubit>(context)
                          .productCategoryEvent(titles[i]);
                    },
                    title: titles[i],
                    categoryName: state.categoryName);
              },
            ),
          ),
          Container(
            color: const Color(0xffF9F9F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    style: TextButton.styleFrom(
                        primary: const Color(0xff222222),
                        textStyle: ETextStyle.metropolis(fontSize: 11)),
                    onPressed: () {},
                    icon: const ImageIcon(
                        AssetImage("assets/images/icons/filter.png")),
                    label: const Text(
                      "Filter",
                    )),
                SortBottomSheet(state: state),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ProductCubit>(context)
                          .productLoadGridLayout();
                    },
                    icon: ImageIcon(AssetImage(state.isGridLayout
                        ? "assets/images/icons/grid.png"
                        : "assets/images/icons/list.png")))
              ],
            ),
          )
        ],
      ),
    );
  }
}