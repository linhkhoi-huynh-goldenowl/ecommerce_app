import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';

import '../../x_result.dart';

abstract class ProductRepository {
  Stream<XResult<List<ProductItem>>> getProductsStream();
  Stream<XResult<List<ProductItem>>> getProductsSaleStream();
  Stream<XResult<List<ProductItem>>> getProductsNewStream();
  Future<XResult<List<ProductItem>>> getProductByTags(List<TagModel> tags);
  Future<XResult<ProductItem>> getProductById(String id);
  Future<XResult<ProductItem>> updateProduct(ProductItem productItem);
}
