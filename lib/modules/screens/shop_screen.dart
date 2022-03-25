import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/screens/shop_category_screen.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:e_commerce_app/widgets/category_title_button.dart';
import 'package:e_commerce_app/widgets/search_text_field.dart';
import 'package:e_commerce_app/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/category/category_cubit.dart';
import '../repositories/category_repository.dart';
import '../repositories/product_repository.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CategoryCubit>(
            create: (BuildContext context) =>
                CategoryCubit(categoryRepository: CategoryRepository()),
          ),
          BlocProvider<ProductCubit>(
            create: (BuildContext context) =>
                ProductCubit(productRepository: ProductRepository()),
          ),
        ],
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
                body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      backgroundColor: const Color(0xffF9F9F9),
                      expandedHeight: 100.0,
                      pinned: true,
                      actions: [_findButton(context)],
                      flexibleSpace: _flexibleSpaceBar(
                          context, state.isSearch, state.searchInput)),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(120.0),
                              child: BlocBuilder<ProductCubit, ProductState>(
                                  builder: (context, state) {
                                return Container(
                                  color: const Color(0xffF9F9F9),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: ButtonIntro(
                                              func: () {
                                                BlocProvider.of<ProductCubit>(
                                                        context)
                                                    .productCategoryEvent(
                                                        "All products");
                                                Navigator.of(context).pushNamed(
                                                    Routes.shopCategoryScreen);
                                              },
                                              title: "VIEW ALL ITEMS"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            "Choose category",
                                            style: ETextStyle.metropolis(
                                                color: const Color(0xff9B9B9B),
                                                fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                );
                              })))),
                ];
              },
              body: state.categories.isEmpty
                  ? const Center(
                      child: Text("No categories"),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryTitleButton(
                          title: state.categories[index],
                          func: () {
                            BlocProvider.of<ProductCubit>(context)
                                .productCategoryEvent(state.categories[index]);
                            Navigator.of(context)
                                .pushNamed(Routes.shopCategoryScreen);
                          },
                        );
                      },
                      itemCount: state.categories.length),
            ));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      });
}

Widget _findButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<CategoryCubit>(context).categoryOpenSearchBar();
      },
      icon: Image.asset('assets/images/icons/find.png'));
}

FlexibleSpaceBar _flexibleSpaceBar(
    BuildContext context, bool isSearch, String searchInput) {
  return FlexibleSpaceBar(
      centerTitle: true,
      title: isSearch == false
          ? Text(
              "Categories",
              style: ETextStyle.metropolis(weight: FontWeight.w600),
            )
          : SearchTextField(
              initValue: searchInput,
              func: (value) {
                BlocProvider.of<CategoryCubit>(context).categorySearch(value);
              }));
}
