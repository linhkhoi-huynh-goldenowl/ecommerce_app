import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/favorite/favorite_cubit.dart';
import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/widgets/favorite_card_grid.dart';
import 'package:e_commerce_app/widgets/favorite_card_list.dart';
import 'package:e_commerce_app/widgets/search_text_field.dart';
import 'package:e_commerce_app/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/filter_bar_widget.dart';
import '../cubit/category/category_cubit.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (BuildContext context) => CategoryCubit(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (BuildContext context) => FavoriteCubit(),
        ),
      ],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        switch (state.status) {
          case FavoriteStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get Favorites')),
            );

          case FavoriteStatus.success:
            return Scaffold(
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
                      flexibleSpace: _flexibleSpaceBar(context, "Favorites",
                          state.isSearch, state.searchInput)),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                        child: PreferredSize(
                            preferredSize: const Size.fromHeight(110.0),
                            child: BlocBuilder<FavoriteCubit, FavoriteState>(
                                buildWhen: (previous, current) =>
                                    previous.status != current.status,
                                builder: (context, state) {
                                  return FilterBarWidget(
                                    chooseCategory: state.categoryName,
                                    applyGrid:
                                        BlocProvider.of<FavoriteCubit>(context)
                                            .favoriteLoadGridLayout,
                                    applyChoose: context
                                        .read<FavoriteCubit>()
                                        .favoriteSort,
                                    chooseSort: state.sort,
                                    isGridLayout: state.isGridLayout,
                                    applyCategory:
                                        BlocProvider.of<FavoriteCubit>(context)
                                            .favoriteCategoryEvent,
                                  );
                                })),
                      ))
                ];
              },
              body: state.searchStatus == SearchProductStatus.loadingSearch ||
                      state.gridStatus == GridProductStatus.loadingGrid
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state.favorites.isEmpty
                      ? const Center(
                          child: Text("No favorites"),
                        )
                      : state.isGridLayout
                          ? _displayGridView(state.favorites)
                          : _displayListView(state.favorites),
            ));

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

GridView _displayGridView(List favorites) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.6,
    ),
    itemBuilder: (BuildContext context, int index) {
      return FavoriteCardGrid(
        favoriteProduct: favorites[index],
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
          left: isSearch == false ? 15 : 40,
          top: isSearch == false ? 0 : 5,
          bottom: isSearch == false ? 11 : 5),
      centerTitle: top > 71 && top < 91 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: isSearch == false
              ? Text(
                  "Favorites",
                  textAlign: TextAlign.start,
                  style: ETextStyle.metropolis(
                      weight: FontWeight.w600, fontSize: 18),
                )
              : SearchTextField(
                  initValue: searchInput,
                  func: (value) {
                    BlocProvider.of<FavoriteCubit>(context)
                        .favoriteSearchEvent(value);
                  })),
    );
  });
}
