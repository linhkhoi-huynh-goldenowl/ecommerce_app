import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/favorite_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/favorite_provider.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  List<FavoriteProduct> _listFavorites = [];
  final FavoriteProvider _favoriteProvider = FavoriteProvider();
  @override
  Future<List<FavoriteProduct>> addProductToFavorite(
      FavoriteProduct item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.id = "$userId-${item.productItem.id}- ${item.size}";
    if (checkNotContainInList(item)) {
      XResult<FavoriteProduct> result =
          await _favoriteProvider.addFavorite(item);
      _listFavorites.add(result.data!);
    }
    return _listFavorites;
  }

  @override
  Future<List<FavoriteProduct>> removeFavorite(FavoriteProduct item) async {
    await _favoriteProvider.removeFavorite(item);
    _listFavorites.removeWhere((element) =>
        element.size == item.size && element.productItem == item.productItem);

    if (_listFavorites
        .where((element) => element.productItem == item.productItem)
        .toList()
        .isEmpty) {}
    return _listFavorites;
  }

  @override
  bool checkContainTitle(String title) {
    return _listFavorites
        .where((element) => element.productItem.title == title)
        .toList()
        .isNotEmpty;
  }

  @override
  bool checkNotContainInList(FavoriteProduct item) {
    return _listFavorites
        .where((element) =>
            element.productItem.title == item.productItem.title &&
            element.size == item.size)
        .toList()
        .isEmpty;
  }

  @override
  Future<List<FavoriteProduct>> getFavorites() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<FavoriteProduct>> result =
        await _favoriteProvider.getFavoritesByUser(userId ?? "");
    _listFavorites = result.data ?? [];
    return _listFavorites;
  }

  @override
  Stream<XResult<List<FavoriteProduct>>> getFavoritesStream() {
    return _favoriteProvider.snapshotsAll();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByPopular(
      List<FavoriteProduct> favorites) async {
    final listFavorites = favorites;
    return listFavorites
        .where((element) => element.productItem.isPopular)
        .toList();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByNewest(
      List<FavoriteProduct> favorites) async {
    var favoritesList = favorites;
    favoritesList.sort((b, a) =>
        a.productItem.createdDate.compareTo(b.productItem.createdDate));
    return favoritesList;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByReview(
      List<FavoriteProduct> favorites) async {
    var favoritesList = favorites;
    favoritesList.sort((b, a) =>
        a.productItem.reviewStars.compareTo(b.productItem.reviewStars));
    return favoritesList;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByLowest(
      List<FavoriteProduct> favorites) async {
    var favoritesList = favorites;
    favorites.sort((a, b) => a.productItem.colors[0].sizes[0].price
        .compareTo(b.productItem.colors[0].sizes[0].price));
    return favoritesList;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByHighest(
      List<FavoriteProduct> favorites) async {
    var favoritesList = favorites;
    favoritesList.sort((b, a) => a.productItem.colors[0].sizes[0].price
        .compareTo(b.productItem.colors[0].sizes[0].price));
    return favoritesList;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByName(
      List<FavoriteProduct> favorites, String searchName) async {
    var favoriteList = favorites;
    return favoriteList
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(searchName.toLowerCase()))
        .toList();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByCategory(
      List<FavoriteProduct> favorites, String categoryName) async {
    var favoriteList = favorites;
    return favoriteList
        .where((element) => element.productItem.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesFilter(
      {String searchName = "",
      ChooseSort chooseSort = ChooseSort.newest,
      String categoryName = ""}) async {
    var favorites = _listFavorites;
    favorites = await getFavoritesByName(favorites, searchName);
    favorites = await getFavoritesByCategory(favorites, categoryName);
    switch (chooseSort) {
      case ChooseSort.popular:
        favorites = await getFavoritesByPopular(favorites);
        break;
      case ChooseSort.newest:
        favorites = await getFavoritesByNewest(favorites);
        break;

      case ChooseSort.review:
        favorites = await getFavoritesByReview(favorites);
        break;
      case ChooseSort.priceLowest:
        favorites = await getFavoritesByLowest(favorites);
        break;
      case ChooseSort.priceHighest:
        favorites = await getFavoritesByHighest(favorites);
        break;
    }

    return favorites;
  }
}
