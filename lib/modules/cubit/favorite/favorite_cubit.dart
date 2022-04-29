import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
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
      if (Domain().favorite.checkNotContainInList(favoriteProduct)) {
        XResult<FavoriteProduct> favoritesRes =
            await Domain().favorite.addProductToFavorite(favoriteProduct);
        if (favoritesRes.isSuccess) {
          final favorites =
              await Domain().favorite.addFavoriteToLocal(favoritesRes.data!);
          emit(state.copyWith(
              status: FavoriteStatus.success,
              favorites: favorites,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: FavoriteStatus.failure, errMessage: favoritesRes.error));
        }
      } else {
        emit(state.copyWith(status: FavoriteStatus.success, errMessage: ""));
      }
    } catch (_) {
      emit(state.copyWith(
          status: FavoriteStatus.failure, errMessage: "Something wrong"));
    }
  }

  void addFavoriteToCart(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(addCartStatus: AddCartStatus.loading));

      CartModel cartModel = CartModel(
          productItem: favoriteProduct.productItem,
          size: favoriteProduct.size,
          color: favoriteProduct.color ?? "Black",
          quantity: 1);
      XResult<CartModel> favoritesRes =
          await Domain().cart.addProductToCart(cartModel);
      if (favoritesRes.isSuccess) {
        emit(state.copyWith(
            addCartStatus: AddCartStatus.success, errMessage: ""));
      } else {
        emit(state.copyWith(
            addCartStatus: AddCartStatus.failure,
            errMessage: favoritesRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          addCartStatus: AddCartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void removeFavorite(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      XResult<String> favoritesRes =
          await Domain().favorite.removeFavorite(favoriteProduct);

      if (favoritesRes.isSuccess) {
        final favorites =
            await Domain().favorite.removeFavoriteToLocal(favoriteProduct);
        emit(state.copyWith(
            status: FavoriteStatus.success,
            favorites: favorites,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: FavoriteStatus.failure, errMessage: favoritesRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: FavoriteStatus.failure, errMessage: "Something wrong"));
    }
  }

  void fetchFavorite() async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));
      XResult<List<FavoriteProduct>> favoritesRes =
          await Domain().favorite.getFavorites();
      if (favoritesRes.isSuccess) {
        final favorites =
            await Domain().favorite.setFavorites(favoritesRes.data!);
        emit(state.copyWith(
            status: FavoriteStatus.success,
            favorites: favorites,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: FavoriteStatus.failure, errMessage: favoritesRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: FavoriteStatus.failure, errMessage: "Something wrong"));
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
          status: FavoriteStatus.success,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          gridStatus: GridFavoriteStatus.failureGrid,
          errMessage: "Something wrong"));
    }
  }

  void favoriteOpenSearchBarEvent() async {
    try {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.loadingGrid));
      emit(state.copyWith(
          isSearch: !state.isSearch,
          gridStatus: GridFavoriteStatus.successGrid,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          gridStatus: GridFavoriteStatus.failureGrid,
          errMessage: "Something wrong"));
    }
  }

  void favoriteOpenCategoryBarEvent() async {
    try {
      emit(state.copyWith(gridStatus: GridFavoriteStatus.loadingGrid));
      emit(state.copyWith(
          isShowCategoryBar: !state.isShowCategoryBar,
          gridStatus: GridFavoriteStatus.successGrid,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          gridStatus: GridFavoriteStatus.failureGrid,
          errMessage: "Something wrong"));
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
            gridStatus: GridFavoriteStatus.successGrid,
            errMessage: ""));
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
            gridStatus: GridFavoriteStatus.successGrid,
            errMessage: ""));
      }
    } catch (_) {
      emit(state.copyWith(
          gridStatus: GridFavoriteStatus.failureGrid,
          errMessage: "Something wrong"));
    }
  }
}
