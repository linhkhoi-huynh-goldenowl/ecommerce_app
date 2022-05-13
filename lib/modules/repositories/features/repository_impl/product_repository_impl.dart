import 'dart:async';

import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/product_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/product_provider.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductProvider _productProvider = ProductProvider();

  @override
  Stream<XResult<List<ProductItem>>> getProductsStream() {
    return _productProvider.snapshotsAll();
  }

  @override
  Stream<XResult<List<ProductItem>>> getProductsNewStream() {
    return _productProvider.snapshotsAllQueryTimeStamp("createdDate");
  }

  @override
  Stream<XResult<List<ProductItem>>> getProductsSaleStream() {
    return _productProvider.snapshotsAllQueryNotNull("salePercent");
  }

  @override
  Future<XResult<ProductItem>> getProductById(String id) async {
    return await _productProvider.getProduct(id);
  }

  @override
  Future<XResult<ProductItem>> updateProduct(ProductItem productItem) async {
    return await _productProvider.updateProduct(productItem);
  }

  @override
  Future<XResult<List<ProductItem>>> getProductSale() async {
    return await _productProvider.getSaleProduct();
  }
}
