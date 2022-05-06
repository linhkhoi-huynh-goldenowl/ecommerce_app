import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/widgets/appbars/flexible_bar_with_search.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_find.dart';
import 'package:e_commerce_shop_app/widgets/cards/shop_product_card.dart';
import 'package:e_commerce_shop_app/widgets/dismiss_keyboard.dart';
import 'package:e_commerce_shop_app/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/buttons/button_leading.dart';
import '../../widgets/appbars/filter_bar_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/cards/main_product_card.dart';

class ShopCategoryScreen extends StatefulWidget {
  const ShopCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ShopCategoryScreen> createState() => _ShopCategoryScreenState();
}

class _ShopCategoryScreenState extends State<ShopCategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animationCategory;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 50, end: 100).animate(
        (CurvedAnimation(parent: _controller, curve: Curves.decelerate)));
    _animationCategory = Tween<double>(begin: 0, end: 50).animate(
        (CurvedAnimation(parent: _controller, curve: Curves.decelerate)));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            return DismissKeyboard(
              child: Scaffold(
                  body: NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _appBar(),
                    _filterBar(),
                  ];
                },
                body: _showItemList(),
              )),
            );

          default:
            return const LoadingWidget();
        }
      },
    );
  }

  Widget _showItemList() {
    return BlocBuilder<ProductCubit, ProductState>(
        buildWhen: (previous, current) =>
            previous.productListToShow != current.productListToShow ||
            previous.isGridLayout != current.isGridLayout,
        builder: (context, state) {
          if (state.productListToShow.isEmpty) {
            return const Center(
              child: Text("No products"),
            );
          } else {
            if (state.isGridLayout) {
              return _displayGridView(state.productListToShow, context);
            } else {
              return _displayListView(state.productListToShow);
            }
          }
        });
  }

  Widget _appBar() {
    return SliverAppBar(
        shadowColor: Colors.white,
        elevation: 5,
        backgroundColor: const Color(0xffF9F9F9),
        expandedHeight: 100.0,
        pinned: true,
        leading: const ButtonLeading(),
        actions: [
          ButtonFind(func: () {
            BlocProvider.of<ProductCubit>(context).productOpenSearchBarEvent();
          })
        ],
        flexibleSpace: BlocBuilder<ProductCubit, ProductState>(
            buildWhen: (previous, current) =>
                previous.isSearch != current.isSearch ||
                previous.searchInput != current.searchInput ||
                previous.categoryName != current.categoryName,
            builder: (context, state) {
              return FlexibleBarWithSearch(
                title: state.type == TypeList.newest
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
                isSearch: state.isSearch,
                searchInput: state.searchInput,
                func: (value) {
                  BlocProvider.of<ProductCubit>(context).productSearch(value);
                },
              );
            }));
  }

  Widget _filterBar() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              child: PreferredSize(
                  preferredSize: Size.fromHeight(_animation.value),
                  child: BlocBuilder<ProductCubit, ProductState>(
                      buildWhen: (previous, current) =>
                          previous.isShowCategoryBar !=
                              current.isShowCategoryBar ||
                          previous.categoryName != current.categoryName ||
                          previous.sort != current.sort ||
                          previous.isGridLayout != current.isGridLayout,
                      builder: (context, state) {
                        return FilterBarWidget(
                          height: _animationCategory.value,
                          showCategory: () async {
                            BlocProvider.of<ProductCubit>(context)
                                .productOpenCategoryBarEvent();
                            if (state.isShowCategoryBar) {
                              await _controller.reverse();
                            } else {
                              await _controller.forward();
                            }
                          },
                          chooseCategory: state.categoryName,
                          applyGrid: BlocProvider.of<ProductCubit>(context)
                              .productLoadGridLayout,
                          applySortCategory: context
                              .read<ProductCubit>()
                              .filterProductCategory,
                          applySortChooseSort:
                              context.read<ProductCubit>().filterProductType,
                          chooseSort: state.sort,
                          isGridLayout: state.isGridLayout,
                        );
                      })),
            ));
      },
    );
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
}
