import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteProduct>> addProductToFavorite(FavoriteProduct item);

  Future<List<ProductItem>> addProducts(ProductItem item);

  bool checkContainProduct(ProductItem item);
  Future<List<FavoriteProduct>> getFavorites();

  Future<List<FavoriteProduct>> getFavoritesByPopular();

  Future<List<FavoriteProduct>> getFavoritesByNewest();
  Future<List<FavoriteProduct>> getFavoritesByReview();

  Future<List<FavoriteProduct>> getFavoritesByLowest();

  Future<List<FavoriteProduct>> getFavoritesByHighest();

  Future<List<FavoriteProduct>> getFavoritesByName(String searchName);

  Future<List<FavoriteProduct>> getFavoritesByCategory(String categoryName);
}
