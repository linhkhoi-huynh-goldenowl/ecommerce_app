import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/widgets/appbars/flexible_bar_with_search.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_find.dart';
import 'package:e_commerce_shop_app/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/helpers/show_snackbar.dart';
import '../../widgets/cards/favorite_card_grid.dart';
import '../../widgets/cards/favorite_card_list.dart';
import '../../widgets/appbars/filter_bar_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/sliver_app_bar_delegate.dart';
import '../cubit/category/category_cubit.dart';
import '../cubit/favorite/favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (BuildContext context) => CategoryCubit(),
        ),
        BlocProvider<ProductCubit>(
          create: (BuildContext context) => ProductCubit(),
        ),
      ],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FavoriteStatus.failure) {
          AppSnackBar.showSnackBar(context, state.errMessage);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case FavoriteStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get Favorites')),
            );

          case FavoriteStatus.success:
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
                      body: _showFavoritesList())),
            );

          default:
            return const LoadingWidget();
        }
      },
    );
  }

  Widget _showFavoritesList() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
        buildWhen: (previous, current) =>
            previous.favoritesListToShow != current.favoritesListToShow ||
            previous.isGridLayout != current.isGridLayout,
        builder: (context, state) {
          return state.favoritesListToShow.isEmpty
              ? const Center(
                  child: Text("No favorites"),
                )
              : state.isGridLayout
                  ? _displayGridView(state.favoritesListToShow, context)
                  : _displayListView(state.favoritesListToShow);
        });
  }

  Widget _appBar() {
    return SliverAppBar(
        shadowColor: Colors.white,
        elevation: 5,
        backgroundColor: const Color(0xffF9F9F9),
        expandedHeight: 100.0,
        pinned: true,
        stretch: true,
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          ButtonFind(func: () {
            BlocProvider.of<FavoriteCubit>(context)
                .favoriteOpenSearchBarEvent();
          }),
        ],
        flexibleSpace: BlocBuilder<FavoriteCubit, FavoriteState>(
            buildWhen: (previous, current) =>
                previous.isSearch != current.isSearch ||
                previous.searchInput != current.searchInput ||
                previous.categoryName != current.categoryName,
            builder: (context, state) {
              return FlexibleBarWithSearch(
                title: "Favorites",
                isSearch: state.isSearch,
                searchInput: state.searchInput,
                func: (value) {
                  BlocProvider.of<FavoriteCubit>(context).favoriteSearch(value);
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
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
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
                            BlocProvider.of<FavoriteCubit>(context)
                                .favoriteOpenCategoryBarEvent();

                            if (state.isShowCategoryBar) {
                              await _controller.reverse();
                            } else {
                              await _controller.forward();
                            }
                          },
                          chooseCategory: state.categoryName,
                          applyGrid: BlocProvider.of<FavoriteCubit>(context)
                              .favoriteLoadGridLayout,
                          applySortCategory: context
                              .read<FavoriteCubit>()
                              .filterFavoriteCategory,
                          applySortChooseSort:
                              context.read<FavoriteCubit>().filterFavoriteType,
                          chooseSort: state.sort,
                          isGridLayout: state.isGridLayout,
                        );
                      })),
            ));
      },
    );
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
}
