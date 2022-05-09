import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';

import '../../modules/models/tag_model.dart';

class FavoriteHelper {
  static List<FavoriteProduct> filterByName(
      String name, List<FavoriteProduct> favoritesList) {
    return favoritesList
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(name.toLowerCase()))
        .toList();
  }

  static List<FavoriteProduct> filterByTag(
      List<TagModel> tagList, List<FavoriteProduct> favoriteFilter) {
    return favoriteFilter
        .where((element) =>
            element.productItem.tags!
                .where((elementTag) => tagList
                    .where((elementTagList) =>
                        elementTagList.name == elementTag.name)
                    .isNotEmpty)
                .length ==
            tagList.length)
        .toList();
  }

  static List<FavoriteProduct> sortByCategory(
      String category, List<FavoriteProduct> favoritesList) {
    return favoritesList
        .where((element) => element.productItem.categoryName
            .toLowerCase()
            .contains(category.toLowerCase()))
        .toList();
  }

  static List<FavoriteProduct> sortByTypeFavorite(
      ChooseSort sort, List<FavoriteProduct> favoritesList) {
    switch (sort) {
      case ChooseSort.popular:
        {
          return favoritesList
              .where((element) => element.productItem.isPopular)
              .toList();
        }
      case ChooseSort.newest:
        {
          var favoritesNews = favoritesList;
          favoritesNews.sort((b, a) => a.productItem.createdDate
              .toDate()
              .compareTo(b.productItem.createdDate.toDate()));
          return favoritesNews;
        }

      case ChooseSort.review:
        {
          var favoritesReview = favoritesList;
          favoritesReview.sort((b, a) =>
              a.productItem.reviewStars.compareTo(b.productItem.reviewStars));
          return favoritesReview;
        }
      case ChooseSort.priceLowest:
        {
          var favoritesLow = favoritesList;
          favoritesLow.sort((a, b) => a.productItem.colors[0].sizes[0].price
              .compareTo(b.productItem.colors[0].sizes[0].price));
          return favoritesLow;
        }
      case ChooseSort.priceHighest:
        {
          var favoritesHigh = favoritesList;
          favoritesHigh.sort((b, a) => a.productItem.colors[0].sizes[0].price
              .compareTo(b.productItem.colors[0].sizes[0].price));
          return favoritesHigh;
        }
    }
  }
}
