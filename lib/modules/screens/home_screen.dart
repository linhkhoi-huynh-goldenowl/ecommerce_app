import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/widgets/carousel.dart';
import 'package:e_commerce_shop_app/widgets/home_label_widget.dart';
import 'package:e_commerce_shop_app/widgets/main_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
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
            child: Column(
              children: [
                BlocBuilder<ProductCubit, ProductState>(
                  buildWhen: (previous, current) =>
                      previous.statusSale != current.statusSale,
                  builder: (context, state) {
                    return HomeLabelWidget(
                        title: "Sale",
                        subTitle: "Super summer sale",
                        func: () {
                          context
                              .read<ProductCubit>()
                              .productSetType(TypeList.sale);
                          Navigator.of(context)
                              .pushNamed(Routes.shopCategoryScreen);
                        });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 300,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) =>
                        previous.statusSale != current.statusSale,
                    builder: (context, state) {
                      return state.statusSale == ProductSaleStatus.loading
                          ? const LoadingWidget()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: MainProductCard(
                                    product: state.productSaleList[index],
                                  ),
                                );
                              },
                              itemCount: state.productSaleList.length > 3
                                  ? 3
                                  : state.productSaleList.length,
                            );
                    },
                  ),
                ),
                BlocBuilder<ProductCubit, ProductState>(
                  buildWhen: (previous, current) =>
                      previous.statusNew != current.statusNew,
                  builder: (context, state) {
                    return HomeLabelWidget(
                        title: "New",
                        subTitle: "You've never seen it before!",
                        func: () {
                          context
                              .read<ProductCubit>()
                              .productSetType(TypeList.newest);
                          Navigator.of(context)
                              .pushNamed(Routes.shopCategoryScreen);
                        });
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 300,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) =>
                        previous.statusNew != current.statusNew,
                    builder: (context, state) {
                      return state.statusNew == ProductNewStatus.loading
                          ? const LoadingWidget()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: MainProductCard(
                                      product: state.productNewList[index]),
                                );
                              },
                              itemCount: state.productNewList.length > 3
                                  ? 3
                                  : state.productNewList.length,
                            );
                    },
                  ),
                ),
              ],
            )),
      ],
    ));
  }
}
