import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';

import '../../x_result.dart';

abstract class FavoriteRepository {
  Future<XResult<FavoriteProduct>> addProductToFavorite(FavoriteProduct item);
  Future<XResult<String>> removeFavorite(FavoriteProduct item);
  Future<Stream<XResult<List<FavoriteProduct>>>> getFavoritesStream();
  Future<XResult<List<FavoriteProduct>>> getFavoritesByUser(String userId);
  Future<XResult<List<FavoriteProduct>>> getFavoritesByProductId(
      String id, String userId);
}
