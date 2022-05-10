import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/category/category_cubit.dart';
import 'package:e_commerce_shop_app/dialogs/sort_bottom_widget.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/cubit/product/product_cubit.dart';
import '../buttons/category_button_chip.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget(
      {Key? key,
      required this.chooseSort,
      required this.isGridLayout,
      required this.applyGrid,
      required this.chooseCategory,
      required this.showCategory,
      required this.height,
      required this.applySortCategory,
      required this.applySortChooseSort,
      required this.showTagList,
      required this.tags})
      : super(key: key);
  final ChooseSort chooseSort;
  final Function(String categoryName) applySortCategory;
  final Function(ChooseSort chooseSort) applySortChooseSort;
  final Function applyGrid;
  final bool isGridLayout;
  final String chooseCategory;
  final Function showCategory;
  final Function showTagList;
  final double height;
  final List<TagModel> tags;
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
          _sortCategory(applySortCategory, chooseCategory, height),
          _filterTags(height, tags),
          _sortFilter(context, chooseSort, applySortChooseSort, isGridLayout,
              applyGrid, showCategory, showTagList)
        ],
      ),
    );
  }
}

Widget _sortCategory(Function(String categoryName) applySortCategory,
    String chooseCategory, double height) {
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
                    applySortCategory(state.categories[i]);
                  },
                  title: state.categories[i],
                );
              });
        },
      ));
}

Widget _filterTags(double height, List<TagModel> tags) {
  return SizedBox(
    height: tags.isNotEmpty ? height : 0,
    child: Row(
      children: [
        Text(
          "Tags:",
          style: ETextStyle.metropolis(fontSize: 14),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: tags.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return _tagChip(tags[i].name);
              }),
        )
      ],
    ),
  );
}

Widget _tagChip(String name) {
  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: InputChip(
      label: Text(
        name,
        style: ETextStyle.metropolis(fontSize: 14, color: Colors.black87),
      ),
      elevation: 2,
      isEnabled: false,
      disabledColor: Colors.white,
    ),
  );
}

Widget _sortFilter(
    BuildContext context,
    ChooseSort chooseSort,
    Function(ChooseSort chooseSort) applySortChooseSort,
    bool isGridLayout,
    Function applyGrid,
    Function showCategory,
    Function showTagList) {
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
          TextButton.icon(
              style: TextButton.styleFrom(
                  primary: const Color(0xff222222),
                  textStyle: ETextStyle.metropolis(fontSize: 11)),
              onPressed: () {
                showTagList();
              },
              icon: const Icon(Icons.tag),
              label: const Text(
                "Tag",
              )),
          SortBottomWidget(
            applySortChooseSort: applySortChooseSort,
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
