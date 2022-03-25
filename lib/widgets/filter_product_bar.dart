import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/category/category_cubit.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sort_button_sheet.dart';
import 'category_button_chip.dart';

class FilterProductBar extends StatelessWidget {
  const FilterProductBar({Key? key}) : super(key: key);

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
              child: BlocBuilder<CategoryCubit, CategoryState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return BlocBuilder<ProductCubit, ProductState>(
                            buildWhen: (previous, current) =>
                                previous.categoryName != current.categoryName,
                            builder: (context, stateProduct) {
                              return CategoryButtonChip(
                                chooseCategory: stateProduct.categoryName,
                                func: () {
                                  BlocProvider.of<ProductCubit>(context)
                                      .productCategoryEvent(
                                          state.categories[i]);
                                },
                                title: state.categories[i],
                              );
                            });
                      },
                    );
                  })),
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
                  BlocBuilder<ProductCubit, ProductState>(
                      buildWhen: (previous, current) =>
                          previous.sort != current.sort,
                      builder: (context, state) {
                        return SortBottomSheet(state: state);
                      }),
                  BlocBuilder<ProductCubit, ProductState>(
                      buildWhen: (previous, current) =>
                          previous.isGridLayout != current.isGridLayout,
                      builder: (context, state) {
                        return IconButton(
                            onPressed: () {
                              BlocProvider.of<ProductCubit>(context)
                                  .productLoadGridLayout();
                            },
                            icon: ImageIcon(AssetImage(state.isGridLayout
                                ? "assets/images/icons/grid.png"
                                : "assets/images/icons/list.png")));
                      }),
                ],
              ))
        ],
      ),
    );
  }
}
