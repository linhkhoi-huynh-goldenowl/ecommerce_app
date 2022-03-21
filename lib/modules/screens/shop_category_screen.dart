import 'package:ecommerce_app/modules/bloc/product/product_bloc.dart';
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
          .map((entry) => Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context)
                        .add(ProductCategoryEvent(categoryName: entry));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: state.categoryName == entry
                        ? const Color(0xffffffff)
                        : const Color(0xff222222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    entry,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Metropolis",
                        color: state.categoryName == entry
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ))
          .toList();
    }

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.failure:
            return const Center(child: Text('failed to Get Products'));

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
                              BlocProvider.of<ProductBloc>(context)
                                  .add(const ProductOpenSearchBarEvent());
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
                              : Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40, top: 40),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ]),
                                  child: TextFormField(
                                    initialValue: state.searchInput,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      BlocProvider.of<ProductBloc>(context).add(
                                          ProductSearchEvent(
                                              searchName: value));
                                    },
                                  ),
                                ))),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          child: PreferredSize(
                              preferredSize: const Size.fromHeight(120.0),
                              child: BlocBuilder<ProductBloc, ProductState>(
                                  builder: (context, state) {
                                return Container(
                                  color: const Color(0xffF9F9F9),
                                  height: 500,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children:
                                              _categoryWidget(context, state),
                                        ),
                                      ),
                                      Container(
                                        color: const Color(0xffF9F9F9),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    primary:
                                                        const Color(0xff222222),
                                                    textStyle: const TextStyle(
                                                        fontFamily:
                                                            "Metropolis",
                                                        fontSize: 11)),
                                                onPressed: () {},
                                                icon: const ImageIcon(AssetImage(
                                                    "assets/images/icons/filter.png")),
                                                label: const Text(
                                                  "Filter",
                                                )),
                                            TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    primary:
                                                        const Color(0xff222222),
                                                    textStyle: const TextStyle(
                                                        fontFamily:
                                                            "Metropolis",
                                                        fontSize: 11)),
                                                onPressed: () {
                                                  showModalBottomSheet<void>(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxHeight: 375),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(40),
                                                              topRight: Radius
                                                                  .circular(
                                                                      40)),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          Image.asset(
                                                            "assets/images/icons/rectangle.png",
                                                            scale: 3,
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          const Text(
                                                            "Sort by",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff222222),
                                                                fontFamily:
                                                                    "Metropolis",
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                            height: 33,
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(const ProductSortEvent(
                                                                        sort: ChooseSort
                                                                            .popular));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                color: state.sort ==
                                                                        ChooseSort
                                                                            .popular
                                                                    ? const Color(
                                                                        0xffDB3022)
                                                                    : null,
                                                                width: double
                                                                    .maxFinite,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                        top: 16,
                                                                        right:
                                                                            0),
                                                                child: Text(
                                                                  "Popular",
                                                                  style: TextStyle(
                                                                      color: state.sort ==
                                                                              ChooseSort
                                                                                  .popular
                                                                          ? const Color(
                                                                              0xffffffff)
                                                                          : const Color(
                                                                              0xff222222),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Metropolis"),
                                                                ),
                                                              )),
                                                          InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(const ProductSortEvent(
                                                                        sort: ChooseSort
                                                                            .newest));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                color: state.sort ==
                                                                        ChooseSort
                                                                            .newest
                                                                    ? const Color(
                                                                        0xffDB3022)
                                                                    : null,
                                                                width: double
                                                                    .maxFinite,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                        top: 16,
                                                                        right:
                                                                            0),
                                                                child: Text(
                                                                  "Newest",
                                                                  style: TextStyle(
                                                                      color: state.sort ==
                                                                              ChooseSort
                                                                                  .newest
                                                                          ? const Color(
                                                                              0xffffffff)
                                                                          : const Color(
                                                                              0xff222222),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Metropolis"),
                                                                ),
                                                              )),
                                                          InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(const ProductSortEvent(
                                                                        sort: ChooseSort
                                                                            .review));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                color: state.sort ==
                                                                        ChooseSort
                                                                            .review
                                                                    ? const Color(
                                                                        0xffDB3022)
                                                                    : null,
                                                                width: double
                                                                    .maxFinite,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                        top: 16,
                                                                        right:
                                                                            0),
                                                                child: Text(
                                                                  "Customer review",
                                                                  style: TextStyle(
                                                                      color: state.sort ==
                                                                              ChooseSort
                                                                                  .review
                                                                          ? const Color(
                                                                              0xffffffff)
                                                                          : const Color(
                                                                              0xff222222),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Metropolis"),
                                                                ),
                                                              )),
                                                          InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(const ProductSortEvent(
                                                                        sort: ChooseSort
                                                                            .priceLowest));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                color: state.sort ==
                                                                        ChooseSort
                                                                            .priceLowest
                                                                    ? const Color(
                                                                        0xffDB3022)
                                                                    : null,
                                                                width: double
                                                                    .maxFinite,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                        top: 16,
                                                                        right:
                                                                            0),
                                                                child: Text(
                                                                  "Price: lowest to high",
                                                                  style: TextStyle(
                                                                      color: state.sort ==
                                                                              ChooseSort
                                                                                  .priceLowest
                                                                          ? const Color(
                                                                              0xffffffff)
                                                                          : const Color(
                                                                              0xff222222),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Metropolis"),
                                                                ),
                                                              )),
                                                          InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<
                                                                            ProductBloc>(
                                                                        context)
                                                                    .add(const ProductSortEvent(
                                                                        sort: ChooseSort
                                                                            .priceHighest));
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                color: state.sort ==
                                                                        ChooseSort
                                                                            .priceHighest
                                                                    ? const Color(
                                                                        0xffDB3022)
                                                                    : null,
                                                                width: double
                                                                    .maxFinite,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        bottom:
                                                                            16,
                                                                        top: 16,
                                                                        right:
                                                                            0),
                                                                child: Text(
                                                                  "Price: highest to low",
                                                                  style: TextStyle(
                                                                      color: state.sort ==
                                                                              ChooseSort
                                                                                  .priceHighest
                                                                          ? const Color(
                                                                              0xffffffff)
                                                                          : const Color(
                                                                              0xff222222),
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "Metropolis"),
                                                                ),
                                                              )),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const ImageIcon(AssetImage(
                                                    "assets/images/icons/range.png")),
                                                label: Text(
                                                  state.sort ==
                                                          ChooseSort.popular
                                                      ? "Popular"
                                                      : state.sort ==
                                                              ChooseSort.newest
                                                          ? "Newest"
                                                          : state.sort ==
                                                                  ChooseSort
                                                                      .review
                                                              ? "Customer Review"
                                                              : state.sort ==
                                                                      ChooseSort
                                                                          .priceLowest
                                                                  ? "Price: lowest to high"
                                                                  : "Price: highest to low",
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<ProductBloc>(
                                                          context)
                                                      .add(
                                                          ProductLoadGridLayoutEvent());
                                                },
                                                icon: ImageIcon(AssetImage(state
                                                        .isGridLayout
                                                    ? "assets/images/icons/grid.png"
                                                    : "assets/images/icons/list.png")))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              })))),
                ];
              },
              body: state.status == ProductStatus.loading
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
