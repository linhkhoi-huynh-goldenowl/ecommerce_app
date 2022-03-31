import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  List<ProductItem> products = <ProductItem>[
    ProductItem(
        "SWE",
        "assets/images/sale_product1.png",
        25,
        3,
        "T-shirt winter",
        DateTime.utc(2022, 3, 24),
        true,
        "Tops",
        "Black", const [
      SizeCloth("XS", 11, 3),
      SizeCloth("S", 12, 2),
      SizeCloth("M", 13, 3),
      SizeCloth("L", 14, 4),
      SizeCloth("XL", 15, 7)
    ]),
    ProductItem(
        "Adidas",
        "assets/images/sale_product2.png",
        11,
        5,
        "Brown Paint",
        DateTime.utc(2022, 3, 21),
        false,
        "Shirts & Blouses",
        "Silver", const [
      SizeCloth("XS", 33, 3),
      SizeCloth("S", 44, 2),
      SizeCloth("M", 45, 3),
      SizeCloth("L", 67, 4),
      SizeCloth("XL", 77, 7)
    ]),
    ProductItem(
        "Dirty Coins",
        "assets/images/sale_product3.png",
        25,
        4,
        "Red Dress flower",
        DateTime.utc(2022, 3, 11),
        false,
        "Tops",
        "Grey",
        const [
          SizeCloth("XS", 44, 3),
          SizeCloth("S", 44, 2),
          SizeCloth("M", 47, 3),
          SizeCloth("L", 47, 4),
          SizeCloth("XL", 52, 7)
        ],
        50),
    ProductItem(
        "DeGrey",
        "assets/images/sale_product4.png",
        13,
        3,
        "Wind jacket",
        DateTime.utc(2022, 2, 23),
        false,
        "Knitwear",
        "White",
        const [
          SizeCloth("XS", 14, 3),
          SizeCloth("S", 24, 2),
          SizeCloth("M", 46, 3),
          SizeCloth("L", 46, 4),
          SizeCloth("XL", 46, 7)
        ],
        20),
    ProductItem(
        "Now",
        "assets/images/sale_product5.png",
        44,
        1,
        "Hoodie Full",
        DateTime.utc(2021, 5, 5),
        false,
        "Tops",
        "Green",
        const [
          SizeCloth("XS", 6, 3),
          SizeCloth("S", 14, 2),
          SizeCloth("M", 14, 3),
          SizeCloth("L", 16, 4),
          SizeCloth("XL", 16, 7)
        ],
        10),
    ProductItem("Puma", "assets/images/sale_product6.png", 23, 4, "Grid short",
        DateTime.utc(2020, 12, 11), false, "Jeans", "Pink", const [
      SizeCloth("XS", 88, 3),
      SizeCloth("S", 90, 2),
      SizeCloth("M", 93, 3),
      SizeCloth("L", 94, 4),
      SizeCloth("XL", 95, 7)
    ]),
    ProductItem("Crown", "assets/images/sale_product7.png", 16, 5, "Anna shirt",
        DateTime.utc(2019, 2, 4), true, "Skirts", "Orange", const [
      SizeCloth("XS", 76, 3),
      SizeCloth("S", 78, 2),
      SizeCloth("M", 79, 3),
      SizeCloth("L", 80, 4),
      SizeCloth("XL", 80, 7)
    ]),
    ProductItem("BiTis", "assets/images/sale_product8.png", 6, 2, "New Skirt",
        DateTime.utc(2022, 1, 27), true, "Shorts", "Yellow", const [
      SizeCloth("XS", 31, 3),
      SizeCloth("S", 32, 2),
      SizeCloth("M", 33, 3),
      SizeCloth("L", 34, 4),
      SizeCloth("XL", 54, 7)
    ]),
    ProductItem(
        "Samsung",
        "assets/images/sale_product9.png",
        66,
        2,
        "Satin Paint",
        DateTime.utc(2021, 10, 17),
        false,
        "Skirts",
        "Red", const [
      SizeCloth("XS", 20, 3),
      SizeCloth("S", 11, 2),
      SizeCloth("M", 12, 3),
      SizeCloth("L", 14, 4),
      SizeCloth("XL", 15, 7)
    ]),
    ProductItem(
        "Apple",
        "assets/images/sale_product10.png",
        4,
        5,
        "T-shirt Hard",
        DateTime.utc(2022, 3, 9),
        true,
        "Dresses",
        "Blue", const [
      SizeCloth("XS", 43, 3),
      SizeCloth("S", 54, 2),
      SizeCloth("M", 64, 3),
      SizeCloth("L", 77, 4),
      SizeCloth("XL", 76, 7)
    ]),
  ];
  @override
  Future<List<ProductItem>> getProducts() async {
    return products;
  }

  @override
  Future<List<ProductItem>> getProductsByType(TypeList typeList) async {
    switch (typeList) {
      case TypeList.all:
        return getProducts();
      case TypeList.newest:
        return await getProductsNew(products);
      case TypeList.sale:
        return await getProductsSale(products);
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
