import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/features/repository/favorite_repository.dart';
import '../product/product_cubit.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required this.favoriteRepository})
      : super(const FavoriteState()) {
    fetchFavorite();
  }

  final FavoriteRepository favoriteRepository;

  void addFavorite(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      var favorites =
          await favoriteRepository.addProductToFavorite(favoriteProduct);
      var products =
          await favoriteRepository.addProducts(favoriteProduct.productItem);
      emit(state.copyWith(
          status: FavoriteStatus.success,
          favorites: favorites,
          size: " ",
          products: products));
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
        final favorites = await favoriteRepository.getFavorites();
        emit(state.copyWith(
            status: FavoriteStatus.success, favorites: favorites));
      }
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
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
      var favorites = await favoriteRepository.getFavoritesByName(searchName);
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
        var favorites = await favoriteRepository.getFavorites();
        emit(state.copyWith(
            categoryName: "All products",
            favorites: favorites,
            status: FavoriteStatus.success));
      } else {
        var favorites =
            await favoriteRepository.getFavoritesByCategory(categoryName);
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
          favorites = await favoriteRepository.getFavoritesByPopular();
          break;
        case ChooseSort.newest:
          favorites = await favoriteRepository.getFavoritesByNewest();
          break;

        case ChooseSort.review:
          favorites = await favoriteRepository.getFavoritesByReview();
          break;
        case ChooseSort.priceLowest:
          favorites = await favoriteRepository.getFavoritesByLowest();
          break;
        case ChooseSort.priceHighest:
          favorites = await favoriteRepository.getFavoritesByHighest();
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
