import 'package:e_commerce_shop_app/modules/models/color_cloth.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/size_cloth.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';

import '../../modules/cubit/product/product_cubit.dart';

class ProductHelper {
  static List getNewsProducts(List products) {
    return products
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  static List getSaleProducts(List products) {
    return products.where((element) => element.salePercent != null).toList();
  }

  static int getIndexOfColor(String color, List<ColorCloth> listColor) {
    int result = listColor.indexWhere((element) => element.color == color);
    return result > -1 ? result : 0;
  }

  static int getIndexOfSize(String size, List<SizeCloth> listSize) {
    int result = listSize.indexWhere((element) => element.size == size);
    return result > -1 ? result : 0;
  }

  static double getPriceItem(
      ProductItem productItem, String color, String size) {
    int indexColor = getIndexOfColor(color, productItem.colors);
    int indexSize = getIndexOfSize(size, productItem.colors[indexColor].sizes);
    return productItem.colors[indexColor].sizes[indexSize].price;
  }

  static double getPriceWithSaleItem(
      ProductItem productItem, String color, String size) {
    if (productItem.salePercent == null) {
      int indexColor = getIndexOfColor(color, productItem.colors);
      int indexSize =
          getIndexOfSize(size, productItem.colors[indexColor].sizes);
      return productItem.colors[indexColor].sizes[indexSize].price;
    } else {
      int indexColor = getIndexOfColor(color, productItem.colors);
      int indexSize =
          getIndexOfSize(size, productItem.colors[indexColor].sizes);
      double price = productItem.colors[indexColor].sizes[indexSize].price;
      price = price - (price * productItem.salePercent! / 100);
      return price;
    }
  }

  static List<ProductItem> filterByName(
      String name, List<ProductItem> productFilter) {
    return productFilter
        .where((element) =>
            element.title.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  static List<ProductItem> sortByCategory(
      String category, List<ProductItem> productFilter) {
    return productFilter
        .where((element) =>
            element.categoryName.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }

  static List<ProductItem> filterByTag(
      List<TagModel> tagList, List<ProductItem> productFilter) {
    return productFilter
        .where((element) =>
            element.tags!
                .where((elementTag) => tagList
                    .where((elementTagList) =>
                        elementTagList.name == elementTag.name)
                    .isNotEmpty)
                .length ==
            tagList.length)
        .toList();
  }

  static List<ProductItem> sortByTypeProduct(
      ChooseSort sort, List<ProductItem> productFilter) {
    switch (sort) {
      case ChooseSort.popular:
        return productFilter.where((element) => element.isPopular).toList();

      case ChooseSort.newest:
        var productsNews = productFilter;
        productsNews.sort(
            (b, a) => a.createdDate.toDate().compareTo(b.createdDate.toDate()));
        return productsNews;
      case ChooseSort.review:
        var productsReview = productFilter;
        productsReview.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
        return productsReview;
      case ChooseSort.priceLowest:
        var productsLow = productFilter;
        productsLow.sort((a, b) =>
            a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
        return productsLow;
      case ChooseSort.priceHighest:
        var productsHigh = productFilter;
        productsHigh.sort((b, a) =>
            a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
        return productsHigh;
    }
  }
}
