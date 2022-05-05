import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/category/category_cubit.dart';
import 'package:e_commerce_shop_app/dialogs/sort_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/cubit/product/product_cubit.dart';
import 'category_button_chip.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget(
      {Key? key,
      required this.chooseSort,
      required this.isGridLayout,
      required this.applyGrid,
      required this.chooseCategory,
      required this.applySort,
      required this.showCategory,
      required this.height})
      : super(key: key);
  final ChooseSort chooseSort;
  final Function(
      {String? categoryName,
      ChooseSort? chooseSort,
      String? searchName}) applySort;
  final Function applyGrid;
  final bool isGridLayout;
  final String chooseCategory;
  final Function showCategory;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            offset: Offset(3.0, 0),
          ),
        ],
        color: Color(0xffF9F9F9),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          _sortCategory(applySort, chooseCategory, height),
          _sortFilter(context, chooseSort, applySort, isGridLayout, applyGrid,
              showCategory)
        ],
      ),
    );
  }
}

Widget _sortCategory(
    Function({String? categoryName, ChooseSort? chooseSort, String? searchName})
        applySort,
    String chooseCategory,
    double height) {
  return SizedBox(
      height: height,
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
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    applySort(categoryName: state.categories[i]);
                  },
                  title: state.categories[i],
                );
              });
        },
      ));
}

Widget _sortFilter(
    BuildContext context,
    ChooseSort chooseSort,
    Function({String? categoryName, ChooseSort? chooseSort, String? searchName})
        applySort,
    bool isGridLayout,
    Function applyGrid,
    Function showCategory) {
  return Container(
      color: const Color(0xffF9F9F9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
              style: TextButton.styleFrom(
                  primary: const Color(0xff222222),
                  textStyle: ETextStyle.metropolis(fontSize: 11)),
              onPressed: () {
                showCategory();
              },
              icon:
                  const ImageIcon(AssetImage("assets/images/icons/filter.png")),
              label: const Text(
                "Filter",
              )),
          SortBottomWidget(
            applySort: applySort,
            chooseSort: chooseSort,
          ),
          IconButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                applyGrid();
              },
              icon: ImageIcon(AssetImage(isGridLayout
                  ? "assets/images/icons/grid.png"
                  : "assets/images/icons/list.png")))
        ],
      ));
}
