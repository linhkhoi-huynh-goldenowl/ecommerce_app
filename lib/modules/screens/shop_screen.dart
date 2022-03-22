import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
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
    final List<Widget> categoriesWidget = titles
        .map((entry) => InkWell(
            onTap: () {
              BlocProvider.of<ProductCubit>(context)
                  .productCategoryEvent(entry);
              Navigator.of(context).pushNamed(Routes.shopCategoryScreen);
            },
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(
                  left: 40, bottom: 16, top: 16, right: 0),
              child: Text(
                entry,
                style: const TextStyle(
                    color: Color(0xff222222),
                    fontSize: 16,
                    fontFamily: "Metropolis"),
              ),
            )))
        .toList();
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
          title: const Text(
            "Categories",
            style: TextStyle(
                color: Color(0xff222222),
                fontFamily: "Metropolis",
                fontWeight: FontWeight.w600),
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
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Choose category",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "Metropolis",
                color: Color(0xff9B9B9B)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoriesWidget,
        )
      ]),
    );
  }
}
