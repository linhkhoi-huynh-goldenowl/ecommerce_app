import 'package:ecommerce_app/config/routes/router.dart';
import 'package:ecommerce_app/modules/cubit/product/product_cubit.dart';
import 'package:ecommerce_app/widgets/button_intro.dart';
import 'package:ecommerce_app/widgets/search_text_field.dart';
import 'package:ecommerce_app/widgets/sliver_appber_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/category/category_cubit.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(builder: (context, state) {
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
                    actions: [
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<CategoryCubit>(context)
                                .categoryOpenSearchBar();
                          },
                          icon: Image.asset('assets/images/icons/find.png'))
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: state.isSearch == false
                            ? const Text(
                                "Categories",
                                style: TextStyle(
                                    color: Color(0xff222222),
                                    fontFamily: "Metropolis",
                                    fontWeight: FontWeight.w600),
                              )
                            : SearchTextField(
                                initValue: state.searchInput,
                                func: (value) {
                                  BlocProvider.of<CategoryCubit>(context)
                                      .categorySearch(value);
                                }))),
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
                                      const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Choose category",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Metropolis",
                                              color: Color(0xff9B9B9B)),
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
                      return InkWell(
                          onTap: () {
                            BlocProvider.of<ProductCubit>(context)
                                .productCategoryEvent(state.categories[index]);
                            Navigator.of(context)
                                .pushNamed(Routes.shopCategoryScreen);
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(
                                left: 40, bottom: 16, top: 16, right: 0),
                            child: Text(
                              state.categories[index],
                              style: const TextStyle(
                                  color: Color(0xff222222),
                                  fontSize: 16,
                                  fontFamily: "Metropolis"),
                            ),
                          ));
                    },
                    itemCount: state.categories.length),
          ));
        default:
          return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
