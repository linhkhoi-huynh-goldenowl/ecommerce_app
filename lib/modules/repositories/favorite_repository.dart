import 'package:e_commerce_app/modules/models/favorite_product.dart';

class FavoriteRepository {
  Future<List> addProductToFavorite(
      List favoriteList, FavoriteProduct item) async {
    if (favoriteList.contains(item)) {
      favoriteList.removeWhere((element) =>
          element.size == item.size && element.productItem == item.productItem);
    } else {
      favoriteList.add(item);
    }
    return favoriteList;
  }

  Future<List> getFavorites() async {
    return <FavoriteProduct>[];
  }

  Future<List> getFavoritesByPopular(List favorites) async {
    return favorites.where((element) => element.productItem.isPopular).toList();
  }

  Future<List> getFavoritesByNewest(List favorites) async {
    favorites.sort((b, a) =>
        a.productItem.createdDate.compareTo(b.productItem.createdDate));
    return favorites;
  }

  Future<List> getFavoritesByReview(List favorites) async {
    favorites.sort((b, a) =>
        a.productItem.reviewStars.compareTo(b.productItem.reviewStars));
    return favorites;
  }

  Future<List> getFavoritesByLowest(List favorites) async {
    favorites
        .sort((a, b) => a.productItem.price.compareTo(b.productItem.price));
    return favorites;
  }

  Future<List> getFavoritesByHighest(List favorites) async {
    favorites
        .sort((b, a) => a.productItem.price.compareTo(b.productItem.price));
    return favorites;
  }

  Future<List> getFavoritesByName(List favorites, String searchName) async {
    return favorites
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(searchName.toLowerCase()))
        .toList();
  }

  Future<List> getFavoritesByCategory(
      List favorites, String categoryName) async {
    return favorites
        .where((element) => element.productItem.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }
}
