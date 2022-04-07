import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/favorite_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/favorite_provider.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';
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
    XResult<FavoriteProduct> result = await _favoriteProvider.addFavorite(item);
    _listFavorites.add(result.data!);
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
  Future<List<FavoriteProduct>> getFavoritesByPopular() async {
    final listFavorites = await getFavorites();
    return listFavorites
        .where((element) => element.productItem.isPopular)
        .toList();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByNewest() async {
    var favorites = _listFavorites;
    favorites.sort((b, a) =>
        a.productItem.createdDate.compareTo(b.productItem.createdDate));
    return favorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByReview() async {
    var favorites = _listFavorites;
    favorites.sort((b, a) =>
        a.productItem.reviewStars.compareTo(b.productItem.reviewStars));
    return favorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByLowest() async {
    var favorites = _listFavorites;
    favorites.sort((a, b) => a.productItem.colors[0].sizes[0].price
        .compareTo(b.productItem.colors[0].sizes[0].price));
    return favorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByHighest() async {
    var favorites = _listFavorites;
    favorites.sort((b, a) => a.productItem.colors[0].sizes[0].price
        .compareTo(b.productItem.colors[0].sizes[0].price));
    return favorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByName(String searchName) async {
    return _listFavorites
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(searchName.toLowerCase()))
        .toList();
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByCategory(
      String categoryName) async {
    return _listFavorites
        .where((element) => element.productItem.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }
}
