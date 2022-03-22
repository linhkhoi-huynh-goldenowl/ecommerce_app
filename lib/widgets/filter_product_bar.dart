import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_sheet_up.dart';

class FilterProductBar extends StatelessWidget {
  const FilterProductBar(
      {Key? key, required this.categoryWidget, required this.state})
      : super(key: key);
  final List<Widget> categoryWidget;
  final ProductState state;
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categoryWidget,
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
                        textStyle: const TextStyle(
                            fontFamily: "Metropolis", fontSize: 11)),
                    onPressed: () {},
                    icon: const ImageIcon(
                        AssetImage("assets/images/icons/filter.png")),
                    label: const Text(
                      "Filter",
                    )),
                BottomSheetUpWidget(state: state),
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
