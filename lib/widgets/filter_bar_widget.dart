import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/category/category_cubit.dart';
import 'package:e_commerce_app/dialogs/sort_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cubit/product/product_cubit.dart';
import 'category_button_chip.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget(
      {Key? key,
      required this.chooseSort,
      required this.applyChoose,
      required this.isGridLayout,
      required this.applyCategory,
      required this.applyGrid,
      required this.chooseCategory})
      : super(key: key);
  final ChooseSort chooseSort;
  final Function(ChooseSort) applyChoose;
  final Function(String) applyCategory;
  final Function applyGrid;
  final bool isGridLayout;
  final String chooseCategory;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF9F9F9),
      height: 500,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _sortCategory(applyCategory, chooseCategory),
          _sortFilter(context, chooseSort, applyChoose, isGridLayout, applyGrid)
        ],
      ),
    );
  }
}

Widget _sortCategory(Function(String) applyCategory, String chooseCategory) {
  return SizedBox(
      height: 50,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return ListView.builder(
              itemCount: state.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return CategoryButtonChip(
                  chooseCategory: chooseCategory,
                  func: () {
                    applyCategory(state.categories[i]);
                  },
                  title: state.categories[i],
                );
              });
        },
      ));
}

Widget _sortFilter(BuildContext context, ChooseSort chooseSort,
    Function(ChooseSort) applyChoose, bool isGridLayout, Function applyGrid) {
  return Container(
      color: const Color(0xffF9F9F9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
              style: TextButton.styleFrom(
                  primary: const Color(0xff222222),
                  textStyle: ETextStyle.metropolis(fontSize: 11)),
              onPressed: () {},
              icon:
                  const ImageIcon(AssetImage("assets/images/icons/filter.png")),
              label: const Text(
                "Filter",
              )),
          SortBottomWidget(
            applyChoose: applyChoose,
            chooseSort: chooseSort,
          ),
          IconButton(
              onPressed: () {
                applyGrid();
              },
              icon: ImageIcon(AssetImage(isGridLayout
                  ? "assets/images/icons/grid.png"
                  : "assets/images/icons/list.png")))
        ],
      ));
}
