import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/widgets/search_text_field.dart';
import 'package:e_commerce_shop_app/widgets/shop_product_card.dart';
import 'package:e_commerce_shop_app/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/filter_bar_widget.dart';
import '../../widgets/main_product_card.dart';

class ShopCategoryScreen extends StatelessWidget {
  const ShopCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get Products')),
            );

          case ProductStatus.success:
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: Scaffold(
                  body: NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        shadowColor: Colors.white,
                        elevation: 5,
                        backgroundColor: const Color(0xffF9F9F9),
                        expandedHeight: 100.0,
                        pinned: true,
                        leading: _leadingButton(context),
                        actions: [_findButton(context)],
                        flexibleSpace: BlocBuilder<ProductCubit, ProductState>(
                            buildWhen: (previous, current) =>
                                previous.gridStatus != current.gridStatus,
                            builder: (context, state) {
                              return _flexibleSpaceBar(
                                  context,
                                  state.type == TypeList.newest
                                      ? ("New - " +
                                          (state.categoryName == ""
                                              ? "All products"
                                              : state.categoryName))
                                      : state.type == TypeList.sale
                                          ? "Sale - " +
                                              (state.categoryName == ""
                                                  ? "All products"
                                                  : state.categoryName)
                                          : "" + state.categoryName == ""
                                              ? "All products"
                                              : state.categoryName,
                                  state.isSearch,
                                  state.searchInput);
                            })),
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(100),
                              child: BlocBuilder<ProductCubit, ProductState>(
                                  buildWhen: (previous, current) =>
                                      previous.gridStatus != current.gridStatus,
                                  builder: (context, state) {
                                    return FilterBarWidget(
                                      showCategory:
                                          BlocProvider.of<ProductCubit>(context)
                                              .productOpenCategoryBarEvent,
                                      isVisible: state.isShowCategoryBar,
                                      chooseCategory: state.categoryName,
                                      applyGrid:
                                          BlocProvider.of<ProductCubit>(context)
                                              .productLoadGridLayout,
                                      applySort: context
                                          .read<ProductCubit>()
                                          .productSort,
                                      chooseSort: state.sort,
                                      isGridLayout: state.isGridLayout,
                                    );
                                  })),
                        )),
                  ];
                },
                body: BlocBuilder<ProductCubit, ProductState>(
                    buildWhen: (previous, current) =>
                        previous.gridStatus != current.gridStatus ||
                        previous.searchStatus != current.searchStatus,
                    builder: (context, state) {
                      if (state.searchStatus ==
                              SearchProductStatus.loadingSearch ||
                          state.gridStatus == GridProductStatus.loadingGrid) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (state.productList.isEmpty) {
                          return const Center(
                            child: Text("No products"),
                          );
                        } else {
                          if (state.isGridLayout) {
                            return _displayGridView(state.productList, context);
                          } else {
                            return _displayListView(state.productList);
                          }
                        }
                      }
                    }),
              )),
            );

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

GridView _displayGridView(List productItems, BuildContext context) {
  return GridView.builder(
    shrinkWrap: true,
    padding: const EdgeInsets.only(top: 32, left: 16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
      childAspectRatio: 0.6,
    ),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: MainProductCard(product: productItems[index]),
      );
    },
    itemCount: productItems.length,
  );
}

ListView _displayListView(List productItems) {
  return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ShopProductCard(
          productItem: productItems[index],
        );
      },
      itemCount: productItems.length);
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      context.read<ProductCubit>().productSort(typeList: TypeList.all);
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

Widget _flexibleSpaceBar(BuildContext context, String categoryName,
    bool isSearch, String searchInput) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    var top = constraints.biggest.height;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
          right: 40,
          left: isSearch == false
              ? top < MediaQuery.of(context).size.height * 0.12
                  ? 40
                  : 16
              : 40,
          top: isSearch == false ? 0 : 5,
          bottom: isSearch == false ? 15 : 5),
      centerTitle:
          top < MediaQuery.of(context).size.height * 0.12 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: isSearch == false
              ? Text(
                  categoryName,
                  style: ETextStyle.metropolis(
                      weight: top < MediaQuery.of(context).size.height * 0.12
                          ? FontWeight.w600
                          : FontWeight.w700,
                      fontSize: 20),
                )
              : SearchTextField(
                  initValue: searchInput,
                  func: (value) {
                    BlocProvider.of<ProductCubit>(context)
                        .productSort(searchName: value);
                  })),
    );
  });
}
