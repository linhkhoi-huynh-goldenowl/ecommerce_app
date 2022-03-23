import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/routes/router.dart';

class CategoryTitleButton extends StatelessWidget {
  const CategoryTitleButton({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          BlocProvider.of<ProductCubit>(context).productCategoryEvent(title);
          Navigator.of(context).pushNamed(Routes.shopCategoryScreen);
        },
        child: Container(
          width: double.maxFinite,
          padding:
              const EdgeInsets.only(left: 40, bottom: 16, top: 16, right: 0),
          child: Text(
            title,
            style: ETextStyle.metropolis(),
          ),
        ));
  }
}
