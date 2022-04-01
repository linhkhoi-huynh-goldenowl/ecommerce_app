import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/product_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/product_provider.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductProvider productProvider = ProductProvider();
  @override
  Future<List<ProductItem>> getProducts() async {
    final XResult<List<ProductItem>> result =
        await productProvider.getAllProduct();
    return result.data ?? <ProductItem>[];
  }

  @override
  Future<List<ProductItem>> getProductsByType(TypeList typeList) async {
    switch (typeList) {
      case TypeList.all:
        return getProducts();
      case TypeList.newest:
        return await getProductsNew(await getProducts());
      case TypeList.sale:
        return await getProductsSale(await getProducts());
    }
  }

  @override
  Future<List<ProductItem>> getProductsNew(List<ProductItem> products) async {
    return products
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  @override
  Future<List<ProductItem>> getProductsSale(List<ProductItem> products) async {
    return products.where((element) => element.salePercent != null).toList();
  }

  @override
  Future<List<ProductItem>> getProductsByPopular(TypeList typeList) async {
    var products = await getProductsByType(typeList);
    return products.where((element) => element.isPopular).toList();
  }

  @override
  Future<List<ProductItem>> getProductsByNewest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.createdDate.compareTo(b.createdDate));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByReview(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByLowest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((a, b) => a.sizes[0].price.compareTo(b.sizes[0].price));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByHighest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.sizes[0].price.compareTo(b.sizes[0].price));
    return productList;
  }

  @override
  Future<List<ProductItem>> getProductsByName(
      TypeList typeList, String searchName) async {
    var products = await getProductsByType(typeList);
    return products
        .where((element) =>
            element.title.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }

  @override
  Future<List<ProductItem>> getProductsByCategory(
      TypeList typeList, String categoryName) async {
    var products = await getProductsByType(typeList);
    return products
        .where((element) => element.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }
}
