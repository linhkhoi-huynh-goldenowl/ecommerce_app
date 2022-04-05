import 'package:e_commerce_app/modules/models/favorite_product.dart';

import '../../x_result.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteProduct>> addProductToFavorite(FavoriteProduct item);
  Future<List<FavoriteProduct>> removeFavorite(FavoriteProduct item);
  bool checkContainTitle(String title);
  Future<List<FavoriteProduct>> getFavorites();
  Stream<XResult<List<FavoriteProduct>>> getFavoritesStream();
  Future<List<FavoriteProduct>> getFavoritesByPopular();

  Future<List<FavoriteProduct>> getFavoritesByNewest();
  Future<List<FavoriteProduct>> getFavoritesByReview();

  Future<List<FavoriteProduct>> getFavoritesByLowest();

  Future<List<FavoriteProduct>> getFavoritesByHighest();

  Future<List<FavoriteProduct>> getFavoritesByName(String searchName);

  Future<List<FavoriteProduct>> getFavoritesByCategory(String categoryName);
}
