import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';

import '../../x_result.dart';

abstract class ProductRepository {
  Future<List<ProductItem>> getProducts();
  Stream<XResult<List<ProductItem>>> getProductsStream();
  Future<ProductItem?> getProductById(String id);
  Future<ProductItem?> updateProduct(ProductItem productItem);
  Future<List<ProductItem>> getProductsByType(TypeList typeList);

  Future<List<ProductItem>> getProductsNew(List<ProductItem> products);

  Future<List<ProductItem>> getProductsSale(List<ProductItem> products);

  Future<List<ProductItem>> getProductsByPopular(TypeList typeList);

  Future<List<ProductItem>> getProductsByNewest(TypeList typeList);
  Future<List<ProductItem>> getProductsByReview(TypeList typeList);

  Future<List<ProductItem>> getProductsByLowest(TypeList typeList);

  Future<List<ProductItem>> getProductsByHighest(TypeList typeList);

  Future<List<ProductItem>> getProductsByName(
      TypeList typeList, String searchName);
  Future<List<ProductItem>> getProductsByCategory(
      TypeList typeList, String categoryName);
}
