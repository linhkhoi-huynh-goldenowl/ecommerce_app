import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/utils/helpers/product_helpers.dart';
import 'package:e_commerce_app/widgets/carousel.dart';
import 'package:e_commerce_app/widgets/home_label_widget.dart';
import 'package:e_commerce_app/widgets/main_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/category/category_cubit.dart';
import 'base_screens/product_coordinator_base.dart';

class HomeScreen extends ProductCoordinatorBase {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CategoryCubit>(
        create: (BuildContext context) => CategoryCubit(),
      ),
      BlocProvider<ProductCubit>(
          create: (BuildContext context) => ProductCubit()),
    ], child: stackView(context));
  }

  @override
  Widget buildInitialBody() {
    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
        body: ListView(
      children: [
        CarouselWidget(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
                  previous.productList != current.productList,
              builder: (context, state) {
                var productNew =
                    ProductHelper.getNewsProducts(state.productList);
                var productSale =
                    ProductHelper.getSaleProducts(state.productList);
                return Column(
                  children: [
                    HomeLabelWidget(
                        title: "Sale",
                        subTitle: "Super summer sale",
                        func: () {
                          context
                              .read<ProductCubit>()
                              .productSort(typeList: TypeList.sale);
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
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: MainProductCard(
                              product: productSale[index],
                            ),
                          );
                        },
                        itemCount:
                            productSale.length > 3 ? 3 : productSale.length,
                      ),
                    ),
                    HomeLabelWidget(
                        title: "New",
                        subTitle: "You've never seen it before!",
                        func: () {
                          context
                              .read<ProductCubit>()
                              .productSort(typeList: TypeList.newest);
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
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: MainProductCard(product: productNew[index]),
                          );
                        },
                        itemCount:
                            productNew.length > 3 ? 3 : productNew.length,
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    ));
  }
}
