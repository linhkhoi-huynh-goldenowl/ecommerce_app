import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';

import '../../../cubit/product/product_cubit.dart';
import '../../x_result.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteProduct>> addProductToFavorite(FavoriteProduct item);
  Future<List<FavoriteProduct>> removeFavorite(FavoriteProduct item);
  bool checkContainTitle(String title);
  bool checkNotContainInList(FavoriteProduct item);
  Future<List<FavoriteProduct>> getFavoritesFilter(
      {String searchName = "",
      ChooseSort chooseSort = ChooseSort.newest,
      String categoryName = ""});
  Future<List<FavoriteProduct>> getFavorites();
  Stream<XResult<List<FavoriteProduct>>> getFavoritesStream();
  Future<List<FavoriteProduct>> getFavoritesByPopular(
      List<FavoriteProduct> favorites);

  Future<List<FavoriteProduct>> getFavoritesByNewest(
      List<FavoriteProduct> favorites);
  Future<List<FavoriteProduct>> getFavoritesByReview(
      List<FavoriteProduct> favorites);

  Future<List<FavoriteProduct>> getFavoritesByLowest(
      List<FavoriteProduct> favorites);

  Future<List<FavoriteProduct>> getFavoritesByHighest(
      List<FavoriteProduct> favorites);

  Future<List<FavoriteProduct>> getFavoritesByName(
      List<FavoriteProduct> favorites, String searchName);

  Future<List<FavoriteProduct>> getFavoritesByCategory(
      List<FavoriteProduct> favorites, String categoryName);
}
