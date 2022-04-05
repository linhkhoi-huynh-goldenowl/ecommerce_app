import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/x_result.dart';
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
        size: " ",
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
        size: " ",
      ));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void chooseSize(String size) async {
    try {
      emit(state.copyWith(size: size));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void fetchFavorite() async {
    try {
      if (state.status == FavoriteStatus.initial) {
        emit(state.copyWith(status: FavoriteStatus.loading));
        final Stream<XResult<List<FavoriteProduct>>> favoritesStream =
            Domain().favorite.getFavoritesStream();

        favoriteSubscription = favoritesStream.listen((event) {
          emit(state.copyWith(
              status: FavoriteStatus.success, favorites: event.data));
        });
      }
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

  void favoriteSearchEvent(String searchName) async {
    try {
      emit(state.copyWith(
          searchStatus: SearchFavoriteStatus.loadingSearch,
          status: FavoriteStatus.loading));
      var favorites = await Domain().favorite.getFavoritesByName(searchName);
      emit(state.copyWith(
          searchStatus: SearchFavoriteStatus.successSearch,
          status: FavoriteStatus.success,
          favorites: favorites,
          searchInput: searchName));
    } catch (_) {
      emit(state.copyWith(searchStatus: SearchFavoriteStatus.failureSearch));
    }
  }

  void favoriteOpenSearchBarEvent() async {
    try {
      // emit(state.copyWith(status: FavoriteStatus.loading));
      emit(state.copyWith(isSearch: !state.isSearch
          // status: FavoriteStatus.success
          ));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void favoriteCategoryEvent(String categoryName) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));
      if (categoryName == "favorites" || categoryName == state.categoryName) {
        var favorites = await Domain().favorite.getFavorites();
        emit(state.copyWith(
            categoryName: "All products",
            favorites: favorites,
            status: FavoriteStatus.success));
      } else {
        var favorites =
            await Domain().favorite.getFavoritesByCategory(categoryName);
        emit(state.copyWith(
            favorites: favorites,
            categoryName: categoryName,
            status: FavoriteStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void favoriteSort(ChooseSort chooseSort) async {
    try {
      var favorites = state.favorites;
      emit(state.copyWith(status: FavoriteStatus.loading));
      switch (chooseSort) {
        case ChooseSort.popular:
          favorites = await Domain().favorite.getFavoritesByPopular();
          break;
        case ChooseSort.newest:
          favorites = await Domain().favorite.getFavoritesByNewest();
          break;

        case ChooseSort.review:
          favorites = await Domain().favorite.getFavoritesByReview();
          break;
        case ChooseSort.priceLowest:
          favorites = await Domain().favorite.getFavoritesByLowest();
          break;
        case ChooseSort.priceHighest:
          favorites = await Domain().favorite.getFavoritesByHighest();
          break;
      }
      emit(state.copyWith(
          sort: chooseSort,
          favorites: favorites,
          status: FavoriteStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }
}
