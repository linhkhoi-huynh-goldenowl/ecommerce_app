import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

import '../x_result.dart';

class FavoriteProvider extends BaseCollectionReference<FavoriteProduct> {
  FavoriteProvider()
      : super(FirebaseFirestore.instance
            .collection('favorites')
            .withConverter<FavoriteProduct>(
                fromFirestore: (snapshot, options) => FavoriteProduct.fromJson(
                    snapshot.data() as Map<String, dynamic>),
                toFirestore: (favorite, _) => favorite.toJson()));

  Future<XResult<FavoriteProduct>> addFavorite(
      FavoriteProduct favoriteProduct) async {
    return await set(favoriteProduct);
  }

  Future<XResult<String>> removeFavorite(
      FavoriteProduct favoriteProduct) async {
    return await remove(favoriteProduct.id ?? "");
  }

  Future<XResult<List<FavoriteProduct>>> getFavoritesByUser(String id) async {
    final XResult<List<FavoriteProduct>> res = await queryWhereId('userId', id);

    return res;
  }
}
