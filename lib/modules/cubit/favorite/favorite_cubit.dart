import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../../utils/helpers/favorite_helpers.dart';
import '../../models/tag_model.dart';
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
      emit(state.copyWith(addStatus: AddFavoriteStatus.loading));
      if (checkNotContainInList(favoriteProduct)) {
        XResult<FavoriteProduct> favoritesRes =
            await Domain().favorite.addProductToFavorite(favoriteProduct);
        if (favoritesRes.isSuccess) {
          emit(state.copyWith(
              addStatus: AddFavoriteStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              addStatus: AddFavoriteStatus.failure,
              errMessage: favoritesRes.error));
        }
      } else {
        emit(state.copyWith(
            addStatus: AddFavoriteStatus.success, errMessage: ""));
      }
    } catch (_) {
      emit(state.copyWith(
          addStatus: AddFavoriteStatus.failure, errMessage: "Something wrong"));
    }
  }

  void removeFavorite(FavoriteProduct favoriteProduct) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      XResult<String> favoritesRes =
          await Domain().favorite.removeFavorite(favoriteProduct);

      if (favoritesRes.isSuccess) {
        emit(state.copyWith(status: FavoriteStatus.success, errMessage: ""));
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
      final Stream<XResult<List<FavoriteProduct>>> favoriteStream =
          await Domain().favorite.getFavoritesStream();

      favoriteSubscription = favoriteStream.listen((event) async {
        emit(state.copyWith(status: FavoriteStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              status: FavoriteStatus.success,
              favorites: event.data,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: FavoriteStatus.failure,
              favorites: [],
              errMessage: event.error));
        }
      });
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
    emit(state.copyWith(isGridLayout: !state.isGridLayout));
  }

  void favoriteOpenSearchBarEvent() async {
    emit(state.copyWith(isSearch: !state.isSearch));
  }

  void favoriteOpenCategoryBarEvent() async {
    emit(state.copyWith(isShowCategoryBar: !state.isShowCategoryBar));
  }

  void favoriteSearch(String searchName) {
    emit(state.copyWith(searchInput: searchName));
  }

  void filterFavoriteCategory(String categoryName) {
    if (categoryName == state.categoryName) {
      emit(state.copyWith(categoryName: ""));
    } else {
      emit(state.copyWith(categoryName: categoryName));
    }
  }

  void filterFavoriteType(ChooseSort chooseSort) {
    emit(state.copyWith(sort: chooseSort));
  }

  bool checkContainId(String id) {
    return state.favorites
        .where((element) => element.productItem.id == id)
        .toList()
        .isNotEmpty;
  }

  bool checkNotContainInList(FavoriteProduct item) {
    return state.favorites
        .where((element) =>
            element.productItem.id == item.productItem.id &&
            element.color == item.color &&
            element.size == item.size)
        .toList()
        .isEmpty;
  }

  void filterFavoriteByTag(List<TagModel> tags) async {
    emit(state.copyWith(tagsFilter: tags));
  }
}
