import 'package:e_commerce_app/modules/models/favorite_product.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final List<FavoriteProduct> _listFavorites = [];
  final List<ProductItem> _listProduct = [];
  @override
  Future<List<FavoriteProduct>> addProductToFavorite(
      FavoriteProduct item) async {
    _listFavorites.add(item);
    return _listFavorites;
  }

  @override
  Future<List<FavoriteProduct>> removeFavorite(FavoriteProduct item) async {
    _listFavorites.removeWhere((element) =>
        element.size == item.size && element.productItem == item.productItem);
    if (_listFavorites
        .where((element) => element.productItem == item.productItem)
        .toList()
        .isEmpty) {
      _listProduct.removeWhere((element) => element == item.productItem);
    }
    return _listFavorites;
  }

  @override
  Future<List<ProductItem>> addProducts(ProductItem item) async {
    _listProduct.add(item);
    return _listProduct;
  }

  @override
  bool checkContainProduct(ProductItem item) {
    if (_listProduct.contains(item)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<FavoriteProduct>> getFavorites() async {
    return _listFavorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByPopular() async {
    return _listFavorites
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
    favorites.sort((a, b) =>
        a.productItem.sizes[0].price.compareTo(b.productItem.sizes[0].price));
    return favorites;
  }

  @override
  Future<List<FavoriteProduct>> getFavoritesByHighest() async {
    var favorites = _listFavorites;
    favorites.sort((b, a) =>
        a.productItem.sizes[0].price.compareTo(b.productItem.sizes[0].price));
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
