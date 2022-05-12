import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/tag/tag_cubit.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_find.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:e_commerce_shop_app/widgets/buttons/category_title_button.dart';
import 'package:e_commerce_shop_app/widgets/textfields/search_text_field.dart';
import 'package:e_commerce_shop_app/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
import '../cubit/category/category_cubit.dart';
import 'base_screens/product_coordinator_base.dart';

class ShopScreen extends ProductCoordinatorBase {
  ShopScreen({required GlobalKey navigatorKey, Key? key})
      : super(key: key, navigatorKey: navigatorKey);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CategoryCubit>(
        create: (BuildContext context) => CategoryCubit(),
      ),
      BlocProvider<ProductCubit>(
          create: (BuildContext context) => ProductCubit()),
      BlocProvider<TagCubit>(create: (BuildContext context) => TagCubit()),
    ], child: stackView(context));
  }

  @override
  Widget buildInitialBody() {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case CategoryStatus.failure:
              return const Scaffold(
                body: Center(child: Text('Failed To Get Category')),
              );
            case CategoryStatus.success:
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xffF9F9F9),
                    elevation: 6,
                    centerTitle: true,
                    actions: [
                      ButtonFind(func: () {
                        BlocProvider.of<CategoryCubit>(context)
                            .categoryOpenSearchBar();
                      })
                    ],
                    title: state.isSearch == false
                        ? Text(
                            "Categories",
                            style: ETextStyle.metropolis(
                                weight: FontWeight.w600, fontSize: 18),
                          )
                        : SearchTextField(
                            initValue: state.searchInput,
                            func: (value) {
                              BlocProvider.of<CategoryCubit>(context)
                                  .categorySearch(value);
                            },
                          ),
                  ),
                  body: NestedScrollView(
                    physics: const BouncingScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        _viewAllItems(),
                      ];
                    },
                    body: _showCategoriesList(),
                  ));
            default:
              return const LoadingWidget();
          }
        });
  }

  Widget _showCategoriesList() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories,
      builder: (context, state) {
        return state.categories.isEmpty
            ? const Center(
                child: Text("No categories"),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return CategoryTitleButton(
                    title: state.categories[index],
                    func: () {
                      BlocProvider.of<ProductCubit>(context)
                          .filterProductCategory(state.categories[index]);
                      Navigator.of(context)
                          .pushNamed(Routes.shopCategoryScreen);
                    },
                  );
                },
                itemCount: state.categories.length);
      },
    );
  }

  Widget _viewAllItems() {
    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            child: PreferredSize(
                preferredSize: const Size.fromHeight(118.0),
                child: BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return Container(
                        color: const Color(0xffF9F9F9),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: ButtonIntro(
                                    func: () {
                                      BlocProvider.of<ProductCubit>(context)
                                          .filterProductCategory("");
                                      Navigator.of(context)
                                          .pushNamed(Routes.shopCategoryScreen);
                                    },
                                    title: "VIEW ALL ITEMS"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Choose category",
                                  style: ETextStyle.metropolis(
                                      color: const Color(0xff9B9B9B),
                                      fontSize: 14),
                                ),
                              ),
                            ]),
                      );
                    }))));
  }
}
