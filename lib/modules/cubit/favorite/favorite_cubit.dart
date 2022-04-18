import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../product/product_cubit.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState()) {
    fetchFavorite();
  }

  StreamSubscription? favoriteSubscription;

  void addFavorite(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      var favorites =
          await Domain().favorite.addProductToFavorite(favoriteProduct);
      emit(state.copyWith(
        status: FavoriteStatus.success,
        favorites: favorites,
      ));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void removeFavorite(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      var favorites = await Domain().favorite.removeFavorite(favoriteProduct);

      emit(state.copyWith(
        status: FavoriteStatus.success,
        favorites: favorites,
      ));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void fetchFavorite() async {
    try {
      // emit(state.copyWith(status: FavoriteStatus.loading));
      // final Stream<XResult<List<FavoriteProduct>>> favoritesStream =
      //     Domain().favorite.getFavoritesStream();

      // favoriteSubscription = favoritesStream.listen((event) {
      //   emit(state.copyWith(
      //       status: FavoriteStatus.success, favorites: event.data));
      // });
      emit(state.copyWith(status: FavoriteStatus.loading));
      final favorites = await Domain().favorite.getFavorites();

      emit(
          state.copyWith(status: FavoriteStatus.success, favorites: favorites));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  @override
  Future<void> close() {
    favoriteSubscription?.cancel();
    return super.close();
  }

  void favoriteLoadGridLayout() async {
    try {
      emit(state.copyWith(
          gridStatus: GridFavoriteStatus.loadingGrid,
          status: FavoriteStatus.loading));
      emit(state.copyWith(
          isGridLayout: !state.isGridLayout,
          gridStatus: GridFavoriteStatus.successGrid,
          status: FavoriteStatus.success));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.failureGrid));
    }
  }

  void favoriteOpenSearchBarEvent() async {
    try {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.loadingGrid));
      emit(state.copyWith(
          isSearch: !state.isSearch,
          gridStatus: GridFavoriteStatus.successGrid));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.failureGrid));
    }
  }

  void favoriteOpenCategoryBarEvent() async {
    try {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.loadingGrid));
      emit(state.copyWith(
          isShowCategoryBar: !state.isShowCategoryBar,
          gridStatus: GridFavoriteStatus.successGrid));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.failureGrid));
    }
  }

  void favoriteSort(
      {String? searchName,
      ChooseSort? chooseSort,
      String? categoryName}) async {
    try {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.loadingGrid));

      if (categoryName == state.categoryName) {
        var favorites = await Domain().favorite.getFavoritesFilter(
            searchName: searchName ?? state.searchInput,
            chooseSort: chooseSort ?? state.sort);

        emit(state.copyWith(
            sort: chooseSort ?? state.sort,
            categoryName: "",
            searchInput: searchName ?? state.searchInput,
            favorites: favorites,
            gridStatus: GridFavoriteStatus.successGrid));
      } else {
        var favorites = await Domain().favorite.getFavoritesFilter(
            searchName: searchName ?? state.searchInput,
            categoryName: categoryName ?? state.categoryName,
            chooseSort: chooseSort ?? state.sort);

        emit(state.copyWith(
            sort: chooseSort ?? state.sort,
            categoryName: categoryName ?? state.categoryName,
            searchInput: searchName ?? state.searchInput,
            favorites: favorites,
            gridStatus: GridFavoriteStatus.successGrid));
      }
    } catch (_) {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.failureGrid));
    }
  }
}
