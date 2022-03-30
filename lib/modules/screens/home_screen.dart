import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/category_repository_impl.dart';
import 'package:e_commerce_app/modules/repositories/features/repository_impl/product_repository_impl.dart';
import 'package:e_commerce_app/utils/helpers/product_helpers.dart';
import 'package:e_commerce_app/widgets/carousel.dart';
import 'package:e_commerce_app/widgets/home_label_widget.dart';
import 'package:e_commerce_app/widgets/main_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/category/category_cubit.dart';
import 'base_screens/product_coordinator_base.dart';

class HomeScreen extends ProductCoordinatorBase {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CategoryCubit>(
        create: (BuildContext context) =>
            CategoryCubit(categoryRepository: CategoryRepositoryImpl()),
      ),
      BlocProvider<ProductCubit>(
        create: (BuildContext context) =>
            ProductCubit(productRepository: ProductRepositoryImpl()),
      ),
    ], child: stackView(context));
  }

  @override
  Widget buildInitialBody() {
    return _buildBody();
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
