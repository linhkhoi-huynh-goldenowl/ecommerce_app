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

  @override
  Future<void> uploadAllProducts() async {
    List<ProductItem> products = <ProductItem>[
      ProductItem(
          id: "P0001",
          brandName: "SWE",
          image: "assets/images/sale_product1.png",
          numberReviews: 25,
          reviewStars: 3,
          title: "T-shirt winter",
          createdDate: DateTime.utc(2022, 3, 24),
          isPopular: true,
          categoryName: "Tops",
          color: "Black",
          sizes: [
            SizeCloth(size: "XS", price: 11, quantity: 3),
            SizeCloth(size: "S", price: 12, quantity: 2),
            SizeCloth(size: "M", price: 14, quantity: 4),
            SizeCloth(size: "L", price: 18, quantity: 5),
            SizeCloth(size: "XL", price: 18, quantity: 1),
          ]),
      ProductItem(
          id: "P0002",
          brandName: "Adidas",
          image: "assets/images/sale_product2.png",
          numberReviews: 11,
          reviewStars: 4,
          title: "Brown Paint",
          createdDate: DateTime.utc(2021, 4, 24),
          isPopular: true,
          categoryName: "Shirts & Blouses",
          color: "Silver",
          sizes: [
            SizeCloth(size: "XS", price: 21, quantity: 3),
            SizeCloth(size: "S", price: 22, quantity: 2),
            SizeCloth(size: "M", price: 24, quantity: 4),
            SizeCloth(size: "L", price: 28, quantity: 5),
            SizeCloth(size: "XL", price: 28, quantity: 1),
          ]),
      ProductItem(
          id: "P0003",
          brandName: "Dirty Coins",
          image: "assets/images/sale_product3.png",
          numberReviews: 14,
          reviewStars: 5,
          title: "Red Dress flower",
          createdDate: DateTime.utc(2022, 3, 11),
          isPopular: false,
          categoryName: "Tops",
          color: "Grey",
          sizes: [
            SizeCloth(size: "XS", price: 23, quantity: 3),
            SizeCloth(size: "S", price: 25, quantity: 2),
            SizeCloth(size: "M", price: 27, quantity: 4),
            SizeCloth(size: "L", price: 28, quantity: 5),
            SizeCloth(size: "XL", price: 28, quantity: 1),
          ],
          salePercent: 50),
      ProductItem(
          id: "P0004",
          brandName: "DeGrey",
          image: "assets/images/sale_product4.png",
          numberReviews: 25,
          reviewStars: 4,
          title: "Wind jacket",
          createdDate: DateTime.utc(2022, 1, 21),
          isPopular: false,
          categoryName: "Knitwear",
          color: "White",
          sizes: [
            SizeCloth(size: "XS", price: 63, quantity: 3),
            SizeCloth(size: "S", price: 65, quantity: 2),
            SizeCloth(size: "M", price: 67, quantity: 4),
            SizeCloth(size: "L", price: 69, quantity: 5),
            SizeCloth(size: "XL", price: 69, quantity: 1),
          ],
          salePercent: 10),
      ProductItem(
          id: "P0005",
          brandName: "Now",
          image: "assets/images/sale_product5.png",
          numberReviews: 3,
          reviewStars: 1,
          title: "Hoodie Full",
          createdDate: DateTime.utc(2021, 10, 11),
          isPopular: true,
          categoryName: "Tops",
          color: "Green",
          sizes: [
            SizeCloth(size: "XS", price: 21, quantity: 3),
            SizeCloth(size: "S", price: 29, quantity: 12),
            SizeCloth(size: "M", price: 32, quantity: 8),
            SizeCloth(size: "L", price: 35, quantity: 5),
            SizeCloth(size: "XL", price: 37, quantity: 11),
          ]),
      ProductItem(
          id: "P0006",
          brandName: "Puma",
          image: "assets/images/sale_product6.png",
          numberReviews: 33,
          reviewStars: 3,
          title: "Grid short",
          createdDate: DateTime.utc(2022, 4, 11),
          isPopular: true,
          categoryName: "Jeans",
          color: "Pink",
          sizes: [
            SizeCloth(size: "XS", price: 31, quantity: 3),
            SizeCloth(size: "S", price: 39, quantity: 12),
            SizeCloth(size: "M", price: 42, quantity: 18),
            SizeCloth(size: "L", price: 45, quantity: 55),
            SizeCloth(size: "XL", price: 47, quantity: 11),
          ]),
      ProductItem(
          id: "P0007",
          brandName: "Crown",
          image: "assets/images/sale_product7.png",
          numberReviews: 33,
          reviewStars: 3,
          title: "Anna shirt",
          createdDate: DateTime.utc(2022, 4, 11),
          isPopular: false,
          categoryName: "Skirts",
          color: "Orange",
          sizes: [
            SizeCloth(size: "XS", price: 13, quantity: 13),
            SizeCloth(size: "S", price: 16, quantity: 12),
            SizeCloth(size: "M", price: 18, quantity: 18),
            SizeCloth(size: "L", price: 22, quantity: 15),
            SizeCloth(size: "XL", price: 23, quantity: 11),
          ]),
      ProductItem(
          id: "P0008",
          brandName: "BiTis",
          image: "assets/images/sale_product8.png",
          numberReviews: 12,
          reviewStars: 2,
          title: "New Skirt",
          createdDate: DateTime.utc(2022, 2, 24),
          isPopular: false,
          categoryName: "Shorts",
          color: "Yellow",
          sizes: [
            SizeCloth(size: "XS", price: 13, quantity: 13),
            SizeCloth(size: "S", price: 16, quantity: 12),
            SizeCloth(size: "M", price: 18, quantity: 18),
            SizeCloth(size: "L", price: 22, quantity: 15),
            SizeCloth(size: "XL", price: 23, quantity: 11),
          ]),
      ProductItem(
          id: "P0009",
          brandName: "Samsung",
          image: "assets/images/sale_product9.png",
          numberReviews: 23,
          reviewStars: 5,
          title: "Satin Paint",
          createdDate: DateTime.utc(2022, 1, 11),
          isPopular: false,
          categoryName: "Skirts",
          color: "Red",
          sizes: [
            SizeCloth(size: "XS", price: 44, quantity: 23),
            SizeCloth(size: "S", price: 44, quantity: 22),
            SizeCloth(size: "M", price: 45, quantity: 38),
            SizeCloth(size: "L", price: 47, quantity: 15),
            SizeCloth(size: "XL", price: 47, quantity: 11),
          ]),
      ProductItem(
          id: "P0010",
          brandName: "Apple",
          image: "assets/images/sale_product10.png",
          numberReviews: 44,
          reviewStars: 3,
          title: "Satin Paint",
          createdDate: DateTime.utc(2022, 4, 11),
          isPopular: false,
          categoryName: "Dresses",
          color: "Blue",
          sizes: [
            SizeCloth(size: "XS", price: 54, quantity: 23),
            SizeCloth(size: "S", price: 54, quantity: 22),
            SizeCloth(size: "M", price: 55, quantity: 38),
            SizeCloth(size: "L", price: 57, quantity: 15),
            SizeCloth(size: "XL", price: 57, quantity: 11),
          ]),
    ];
    for (ProductItem element in products) {
      await productProvider.createProduct(element);
    }
  }
}
