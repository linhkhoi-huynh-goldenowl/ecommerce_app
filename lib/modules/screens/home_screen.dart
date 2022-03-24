import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/modules/screens/shop_category_screen.dart';
import 'package:ecommerce_app/utils/helpers/product_helpers.dart';
import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/home_label_widget.dart';
import 'package:ecommerce_app/widgets/main_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/product_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
        create: (BuildContext context) =>
            ProductCubit(productRepository: ProductRepository()),
        child: Navigator(
          onGenerateRoute: (settings) {
            Widget page = _buildBody();
            if (settings.name == Routes.shopCategoryScreen) {
              page = const ShopCategoryScreen();
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        ));
  }
}

Widget _buildBody() {
  return Scaffold(
      body: ListView(
    children: [
      const CarouselWidget(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: BlocBuilder<ProductCubit, ProductState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              ProductHelper helper = ProductHelper();
              var productNew = helper.getNewsProducts(state.productList);
              var productSale = helper.getSaleProducts(state.productList);
              return Column(
                children: [
                  HomeLabelWidget(
                      title: "Sale",
                      subTitle: "Super summer sale",
                      func: () {
                        context.read<ProductCubit>().productSaleLoaded();
                        Navigator.of(context)
                            .pushNamed(Routes.shopCategoryScreen);
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return MainProductCard(product: productSale[index]);
                      },
                      itemCount:
                          productSale.length > 3 ? 3 : productSale.length,
                    ),
                  ),
                  HomeLabelWidget(
                      title: "New",
                      subTitle: "You've never seen it before!",
                      func: () {
                        context.read<ProductCubit>().productNewLoaded();
                        Navigator.of(context)
                            .pushNamed(Routes.shopCategoryScreen);
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return MainProductCard(product: productNew[index]);
                      },
                      itemCount: productNew.length > 3 ? 3 : productNew.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    ],
  ));
}
