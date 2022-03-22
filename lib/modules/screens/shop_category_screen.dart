import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/widgets/category_button_chip.dart';
import 'package:ecommerce_app/widgets/filter_product_bar.dart';
import 'package:ecommerce_app/widgets/search_text_field.dart';
import 'package:ecommerce_app/widgets/shop_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/main_product_card.dart';

class ShopCategoryScreen extends StatelessWidget {
  ShopCategoryScreen({Key? key}) : super(key: key);

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
    List<Widget> _categoryWidget(BuildContext context, ProductState state) {
      return titles
          .map((entry) => CategoryButtonChip(
              func: () {
                BlocProvider.of<ProductCubit>(context)
                    .productCategoryEvent(entry);
              },
              title: entry,
              categoryName: state.categoryName))
          .toList();
    }

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get Products')),
            );

          case ProductStatus.success:
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
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<ProductCubit>(context)
                                  .productOpenSearchBarEvent();
                            },
                            icon: Image.asset('assets/images/icons/find.png'))
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: state.isSearch == false
                              ? Text(
                                  state.categoryName,
                                  style: const TextStyle(
                                      color: Color(0xff222222),
                                      fontFamily: "Metropolis",
                                      fontWeight: FontWeight.w600),
                                )
                              : SearchTextField(
                                  initValue: state.searchInput,
                                  func: (value) {
                                    BlocProvider.of<ProductCubit>(context)
                                        .productSearchEvent(value);
                                  }))),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(120.0),
                              child: BlocBuilder<ProductCubit, ProductState>(
                                  builder: (context, state) {
                                return FilterProductBar(
                                    categoryWidget:
                                        _categoryWidget(context, state),
                                    state: state);
                              })))),
                ];
              },
              body: state.searchStatus == SearchProductStatus.loadingSearch ||
                      state.gridStatus == GridProductStatus.loadingGrid
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.productList.isEmpty
                      ? const Center(
                          child: Text("No products"),
                        )
                      : state.isGridLayout
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                childAspectRatio: 0.6,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return MainProductCard(
                                    title: state.productList[index].title,
                                    brandName:
                                        state.productList[index].brandName,
                                    image: state.productList[index].image,
                                    price: state.productList[index].price,
                                    isNew:
                                        state.productList[index].createdDate ==
                                            DateTime.now(),
                                    priceSale:
                                        state.productList[index].priceSale,
                                    salePercent: state
                                                .productList[index].priceSale !=
                                            null
                                        ? (1 -
                                                (state.productList[index]
                                                            .priceSale! /
                                                        state.productList[index]
                                                            .price)
                                                    .roundToDouble()) *
                                            100
                                        : null,
                                    numberReviews:
                                        state.productList[index].numberReviews,
                                    reviewStars:
                                        state.productList[index].reviewStars);
                              },
                              itemCount: state.productList.length,
                            )
                          : ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return ShopProductCard(
                                    title: state.productList[index].title,
                                    brandName:
                                        state.productList[index].brandName,
                                    image: state.productList[index].image,
                                    price: state.productList[index].price,
                                    isNew:
                                        state.productList[index].createdDate ==
                                            DateTime.now(),
                                    priceSale:
                                        state.productList[index].priceSale,
                                    salePercent: state
                                                .productList[index].priceSale !=
                                            null
                                        ? (1 -
                                                (state.productList[index]
                                                            .priceSale! /
                                                        state.productList[index]
                                                            .price)
                                                    .roundToDouble()) *
                                            100
                                        : null,
                                    numberReviews:
                                        state.productList[index].numberReviews,
                                    reviewStars:
                                        state.productList[index].reviewStars);
                              },
                              itemCount: state.productList.length),
            ));

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
