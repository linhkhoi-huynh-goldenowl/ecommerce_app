import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/favorite_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/favorite_provider.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteProvider _favoriteProvider = FavoriteProvider();
  @override
  Future<XResult<FavoriteProduct>> addProductToFavorite(
      FavoriteProduct item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.id = "$userId-${item.productItem.id}- ${item.size}";
    return await _favoriteProvider.addFavorite(item);
  }

  @override
  Future<XResult<String>> removeFavorite(FavoriteProduct item) async {
    return await _favoriteProvider.removeFavorite(item);
  }

  @override
  Future<Stream<XResult<List<FavoriteProduct>>>> getFavoritesStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _favoriteProvider.snapshotsAllQuery("userId", userId);
  }

  @override
  Future<XResult<List<FavoriteProduct>>> getFavoritesByProductId(
      String id, String userId) async {
    return await _favoriteProvider.queryWhereEqualTwoParam(
        "productItem.id", id, "userId", userId);
  }

  @override
  Future<XResult<List<FavoriteProduct>>> getFavoritesByUser(
      String userId) async {
    return await _favoriteProvider.queryWhereEqual("userId", userId);
  }
}
