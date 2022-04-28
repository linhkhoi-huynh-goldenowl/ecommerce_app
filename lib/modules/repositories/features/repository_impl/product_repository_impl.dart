import 'dart:async';

import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/product_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/product_provider.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductProvider _productProvider = ProductProvider();
  List<ProductItem> _listProduct = [];

  @override
  Stream<XResult<List<ProductItem>>> getProductsStream() {
    return _productProvider.snapshotsAll();
  }

  @override
  Future<List<ProductItem>> setProducts(List<ProductItem> products) async {
    _listProduct = products;
    return _listProduct;
  }

  @override
  Future<List<ProductItem>> getProductsByType(TypeList typeList) async {
    switch (typeList) {
      case TypeList.all:
        return _listProduct;
      case TypeList.newest:
        return await getProductsNew(_listProduct);
      case TypeList.sale:
        return await getProductsSale(_listProduct);
    }
  }

  @override
  Future<List<ProductItem>> getProductsNew(List<ProductItem> products) async {
    var productsList = products;
    return productsList
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  @override
  Future<List<ProductItem>> getProductsSale(List<ProductItem> products) async {
    var productsList = products;
    return productsList
        .where((element) => element.salePercent != null)
        .toList();
  }

  @override
  Future<List<ProductItem>> getProductsByPopular(
      List<ProductItem> products) async {
    return products.where((element) => element.isPopular).toList();
  }

  @override
  Future<List<ProductItem>> getProductsByNewest(
      List<ProductItem> products) async {
    products.sort((b, a) => a.createdDate.compareTo(b.createdDate));
    return products;
  }

  @override
  Future<List<ProductItem>> getProductsByReview(
      List<ProductItem> products) async {
    var productList = products;
    productList.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByLowest(
      List<ProductItem> products) async {
    var productList = products;
    productList.sort((a, b) =>
        a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByHighest(
      List<ProductItem> products) async {
    var productList = products;
    productList.sort((b, a) =>
        a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByName(
      List<ProductItem> products, String searchName) async {
    var productList = products;
    return productList
        .where((element) =>
            element.title.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }

  @override
  Future<List<ProductItem>> getProductsByCategory(
      List<ProductItem> products, String categoryName) async {
    return products
        .where((element) => element.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }

  @override
  Future<ProductItem?> getProductById(String id) async {
    final findResult =
        _listProduct.where((element) => element.id == id).toList();
    if (findResult.isNotEmpty) {
      return findResult[0];
    } else {
      return null;
    }
  }

  @override
  Future<XResult<ProductItem>> updateProduct(ProductItem productItem) async {
    return await _productProvider.updateProduct(productItem);
  }

  @override
  Future<List<ProductItem>> getProductsFilter(
      {String searchName = "",
      TypeList typeList = TypeList.all,
      ChooseSort chooseSort = ChooseSort.newest,
      String categoryName = ""}) async {
    var products = await getProductsByType(typeList);
    products = await getProductsByName(products, searchName);
    products = await getProductsByCategory(products, categoryName);
    switch (chooseSort) {
      case ChooseSort.popular:
        products = await getProductsByPopular(products);
        break;
      case ChooseSort.newest:
        products = await getProductsByNewest(products);
        break;

      case ChooseSort.review:
        products = await getProductsByReview(products);
        break;
      case ChooseSort.priceLowest:
        products = await getProductsByLowest(products);
        break;
      case ChooseSort.priceHighest:
        products = await getProductsByHighest(products);
        break;
    }
    return products;
  }
}
