import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/styles/text_style.dart';
import '../../widgets/favorite_card_grid.dart';
import '../../widgets/favorite_card_list.dart';
import '../../widgets/filter_bar_widget.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/sliver_app_bar_delegate.dart';
import '../cubit/category/category_cubit.dart';
import '../cubit/favorite/favorite_cubit.dart';
import '../cubit/product/product_cubit.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (BuildContext context) => CategoryCubit(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case FavoriteStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get Favorites')),
            );

          case FavoriteStatus.success:
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
                              stretch: true,
                              automaticallyImplyLeading: false,
                              leading: null,
                              actions: [_findButton(context)],
                              flexibleSpace:
                                  BlocBuilder<FavoriteCubit, FavoriteState>(
                                      buildWhen: (previous, current) =>
                                          previous.gridStatus !=
                                          current.gridStatus,
                                      builder: (context, state) {
                                        return _flexibleSpaceBar(
                                            context,
                                            "Favorites",
                                            state.isSearch,
                                            state.searchInput);
                                      })),
                          SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverAppBarDelegate(
                                child: PreferredSize(
                                    preferredSize: const Size.fromHeight(100.0),
                                    child: BlocBuilder<FavoriteCubit,
                                            FavoriteState>(
                                        buildWhen: (previous, current) =>
                                            previous.gridStatus !=
                                            current.gridStatus,
                                        builder: (context, state) {
                                          return FilterBarWidget(
                                            isVisible: state.isShowCategoryBar,
                                            showCategory: BlocProvider.of<
                                                    FavoriteCubit>(context)
                                                .favoriteOpenCategoryBarEvent,
                                            chooseCategory: state.categoryName,
                                            applyGrid:
                                                BlocProvider.of<FavoriteCubit>(
                                                        context)
                                                    .favoriteLoadGridLayout,
                                            applySort: context
                                                .read<FavoriteCubit>()
                                                .favoriteSort,
                                            chooseSort: state.sort,
                                            isGridLayout: state.isGridLayout,
                                          );
                                        })),
                              ))
                        ];
                      },
                      body: BlocBuilder<FavoriteCubit, FavoriteState>(
                          buildWhen: (previous, current) =>
                              previous.gridStatus != current.gridStatus,
                          builder: (context, state) {
                            return state.searchStatus ==
                                        SearchProductStatus.loadingSearch ||
                                    state.gridStatus ==
                                        GridProductStatus.loadingGrid
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : state.favorites.isEmpty
                                    ? const Center(
                                        child: Text("No favorites"),
                                      )
                                    : state.isGridLayout
                                        ? _displayGridView(
                                            state.favorites, context)
                                        : _displayListView(state.favorites);
                          }))),
            );

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

GridView _displayGridView(List favorites, BuildContext context) {
  return GridView.builder(
    padding: const EdgeInsets.only(left: 16, top: 32),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
      childAspectRatio: 0.55,
    ),
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: FavoriteCardGrid(
          favoriteProduct: favorites[index],
        ),
      );
    },
    itemCount: favorites.length,
  );
}

ListView _displayListView(List favorites) {
  return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return FavoriteCardList(
          favoriteProduct: favorites[index],
        );
      },
      itemCount: favorites.length);
}

Widget _findButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        BlocProvider.of<FavoriteCubit>(context).favoriteOpenSearchBarEvent();
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
                  "Favorites",
                  textAlign: TextAlign.start,
                  style: ETextStyle.metropolis(
                      weight: top < MediaQuery.of(context).size.height * 0.12
                          ? FontWeight.w600
                          : FontWeight.w700,
                      fontSize: top < MediaQuery.of(context).size.height * 0.12
                          ? 20
                          : 26),
                )
              : SearchTextField(
                  initValue: searchInput,
                  func: (value) {
                    BlocProvider.of<FavoriteCubit>(context)
                        .favoriteSort(searchName: value);
                  })),
    );
  });
}
