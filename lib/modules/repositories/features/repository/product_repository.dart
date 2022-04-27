import 'package:e_commerce_shop_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';

import '../../x_result.dart';

abstract class ProductRepository {
  List<ProductItem> getProducts();
  void setProducts(List<ProductItem> products);
  Stream<XResult<List<ProductItem>>> getProductsStream();
  Future<ProductItem?> getProductById(String id);
  Future<ProductItem?> updateProduct(ProductItem productItem);
  Future<List<ProductItem>> getProductsFilter(
      {String searchName = "",
      TypeList typeList = TypeList.all,
      ChooseSort chooseSort = ChooseSort.newest,
      String categoryName = ""});
  Future<List<ProductItem>> getProductsByType(TypeList typeList);

  Future<List<ProductItem>> getProductsNew(List<ProductItem> products);

  Future<List<ProductItem>> getProductsSale(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByPopular(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByNewest(List<ProductItem> products);
  Future<List<ProductItem>> getProductsByReview(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByLowest(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByHighest(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByName(
      List<ProductItem> products, String searchName);
  Future<List<ProductItem>> getProductsByCategory(
      List<ProductItem> products, String categoryName);
}
