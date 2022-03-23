import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:ecommerce_app/widgets/category_title_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatelessWidget {
  ShopScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF9F9F9),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/icons/find.png'))
          ],
          centerTitle: true,
          title: Text(
            "Categories",
            style: ETextStyle.metropolis(weight: FontWeight.w600),
          )),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: ButtonIntro(
              func: () {
                BlocProvider.of<ProductCubit>(context)
                    .productCategoryEvent("All products");
                Navigator.of(context).pushNamed(Routes.shopCategoryScreen);
              },
              title: "VIEW ALL ITEMS"),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "Choose category",
            style: ETextStyle.metropolis(
                fontSize: 14, color: const Color(0xff9B9B9B)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              titles.map((entry) => CategoryTitleButton(title: entry)).toList(),
        )
      ]),
    );
  }
}
