import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/repositories/favorite_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({required this.favoriteRepository})
      : super(const FavoriteState()) {
    favoriteLoaded();
  }

  final FavoriteRepository favoriteRepository;

  void addFavorite(FavoriteProduct productItem) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      var favorites = await favoriteRepository.addProductToFavorite(
          state.favorites, productItem);
      emit(state.copyWith(
          status: FavoriteStatus.success, favorites: favorites, size: " "));
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

  void favoriteLoaded() async {
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
      var favorites = await favoriteRepository.getFavoritesByName(
          state.favorites, searchName);
      emit(state.copyWith(
          favoritesListSub: favorites,
          searchStatus: SearchFavoriteStatus.successSearch,
          status: FavoriteStatus.success,
          searchInput: searchName));
    } catch (_) {
      emit(state.copyWith(searchStatus: SearchFavoriteStatus.failureSearch));
    }
  }

  void favoriteOpenSearchBarEvent() async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));
      emit(state.copyWith(
          isSearch: !state.isSearch,
          useListSub: !state.useListSub,
          status: FavoriteStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void favoriteCategoryEvent(String categoryName) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));
      if (categoryName == "favorites" || categoryName == state.categoryName) {
        emit(state.copyWith(
            categoryName: "All products",
            useListSub: false,
            status: FavoriteStatus.success));
      } else {
        var favorites = await favoriteRepository.getFavoritesByCategory(
            state.favorites, categoryName);
        emit(state.copyWith(
            categoryName: categoryName,
            favoritesListSub: favorites,
            useListSub: true,
            status: FavoriteStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }

  void favoriteSort(ChooseSortFavorite chooseSort) async {
    try {
      var favorites = state.favorites;
      emit(state.copyWith(status: FavoriteStatus.loading));
      switch (chooseSort) {
        case ChooseSortFavorite.popular:
          favorites =
              await favoriteRepository.getFavoritesByPopular(state.favorites);
          break;
        case ChooseSortFavorite.newest:
          favorites =
              await favoriteRepository.getFavoritesByNewest(state.favorites);
          break;

        case ChooseSortFavorite.review:
          favorites =
              await favoriteRepository.getFavoritesByReview(state.favorites);
          break;
        case ChooseSortFavorite.priceLowest:
          favorites =
              await favoriteRepository.getFavoritesByLowest(state.favorites);
          break;
        case ChooseSortFavorite.priceHighest:
          favorites =
              await favoriteRepository.getFavoritesByHighest(state.favorites);
          break;
      }
      emit(state.copyWith(
          sort: chooseSort,
          useListSub: true,
          favoritesListSub: favorites,
          status: FavoriteStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.failure));
    }
  }
}
