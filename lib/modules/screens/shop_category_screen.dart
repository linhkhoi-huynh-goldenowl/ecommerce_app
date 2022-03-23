import 'package:ecommerce_app/config/styles/text_style.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/widgets/filter_product_bar.dart';
import 'package:ecommerce_app/widgets/search_text_field.dart';
import 'package:ecommerce_app/widgets/shop_product_card.dart';
import 'package:ecommerce_app/widgets/sliver_appber_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/main_product_card.dart';

class ShopCategoryScreen extends StatelessWidget {
  const ShopCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      leading: _leadingButton(context),
                      actions: [_findButton(context)],
                      flexibleSpace: _flexibleSpaceBar(
                          context,
                          state.categoryName,
                          state.isSearch,
                          state.searchInput)),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(120.0),
                              child: BlocBuilder<ProductCubit, ProductState>(
                                  builder: (context, state) {
                                return FilterProductBar(state: state);
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
                          ? _displayGridview(state.productList)
                          : _displayListView(state.productList),
            ));

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

GridView _displayGridview(List productItems) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 300,
      childAspectRatio: 0.6,
    ),
    itemBuilder: (BuildContext context, int index) {
      return MainProductCard(
          title: productItems[index].title,
          brandName: productItems[index].brandName,
          image: productItems[index].image,
          price: productItems[index].price,
          isNew: productItems[index].createdDate == DateTime.now(),
          priceSale: productItems[index].priceSale,
          salePercent: productItems[index].priceSale != null
              ? (1 -
                      (productItems[index].priceSale! /
                              productItems[index].price)
                          .roundToDouble()) *
                  100
              : null,
          numberReviews: productItems[index].numberReviews,
          reviewStars: productItems[index].reviewStars);
    },
    itemCount: productItems.length,
  );
}

ListView _displayListView(List productItems) {
  return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ShopProductCard(
            title: productItems[index].title,
            brandName: productItems[index].brandName,
            image: productItems[index].image,
            price: productItems[index].price,
            isNew: productItems[index].createdDate == DateTime.now(),
            priceSale: productItems[index].priceSale,
            salePercent: productItems[index].priceSale != null
                ? (1 -
                        (productItems[index].priceSale! /
                                productItems[index].price)
                            .roundToDouble()) *
                    100
                : null,
            numberReviews: productItems[index].numberReviews,
            reviewStars: productItems[index].reviewStars);
      },
      itemCount: productItems.length);
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget _findButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<ProductCubit>(context).productOpenSearchBarEvent();
      },
      icon: Image.asset('assets/images/icons/find.png'));
}

FlexibleSpaceBar _flexibleSpaceBar(BuildContext context, String categoryName,
    bool isSearch, String searchInput) {
  return FlexibleSpaceBar(
      centerTitle: true,
      title: isSearch == false
          ? Text(
              categoryName,
              style: ETextStyle.metropolis(weight: FontWeight.w600),
            )
          : SearchTextField(
              initValue: searchInput,
              func: (value) {
                BlocProvider.of<ProductCubit>(context)
                    .productSearchEvent(value);
              }));
}
