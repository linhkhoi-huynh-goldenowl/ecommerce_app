import 'package:e_commerce_app/modules/cubit/product/product_cubit.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';

class ProductRepository {
  List<ProductItem> products = <ProductItem>[
    ProductItem(
      "SWE",
      "assets/images/sale_product1.png",
      25,
      12,
      4,
      "T-shirt winter",
      DateTime.utc(2022, 3, 24),
      true,
      "Tops",
    ),
    ProductItem(
      "Adidas",
      "assets/images/sale_product2.png",
      11,
      4,
      5,
      "Brown Paint",
      DateTime.utc(2022, 3, 21),
      false,
      "Shirts & Blouses",
    ),
    ProductItem("Dirty Coins", "assets/images/sale_product3.png", 25, 5, 5,
        "Red Dress flower", DateTime.utc(2022, 3, 11), false, "Tops", 22),
    ProductItem("Degrey", "assets/images/sale_product4.png", 35, 13, 3,
        "Wind jacket", DateTime.utc(2022, 2, 23), false, "Knitwear", 21),
    ProductItem("Now", "assets/images/sale_product5.png", 23, 44, 1,
        "Hoodie Full", DateTime.utc(2021, 5, 5), false, "Tops", 12),
    ProductItem(
      "Puma",
      "assets/images/sale_product6.png",
      11,
      23,
      4,
      "Grid short",
      DateTime.utc(2020, 12, 11),
      false,
      "Jeans",
    ),
    ProductItem(
      "Crownz",
      "assets/images/sale_product7.png",
      64,
      16,
      5,
      "Anna shirt",
      DateTime.utc(2019, 2, 4),
      true,
      "Skirts",
    ),
    ProductItem(
      "Bitis",
      "assets/images/sale_product8.png",
      35,
      6,
      2,
      "New Skirt",
      DateTime.utc(2022, 1, 27),
      true,
      "Shorts",
    ),
    ProductItem(
      "Samsung",
      "assets/images/sale_product9.png",
      6,
      66,
      2,
      "Satin Paint",
      DateTime.utc(2021, 10, 17),
      false,
      "Skirts",
    ),
    ProductItem(
      "Apple",
      "assets/images/sale_product10.png",
      12,
      4,
      5,
      "T-shirt Hard",
      DateTime.utc(2022, 3, 9),
      true,
      "Dresses",
    ),
  ];
  Future<List<ProductItem>> getProducts() async {
    return products;
  }

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

  Future<List<ProductItem>> getProductsNew(List<ProductItem> productss) async {
    return productss
        .where((element) =>
            (element.createdDate.month == DateTime.now().month &&
                element.createdDate.year == DateTime.now().year))
        .toList();
  }

  Future<List<ProductItem>> getProductsSale(List<ProductItem> productss) async {
    return productss.where((element) => element.priceSale != null).toList();
  }

  Future<List<ProductItem>> getProductsByPopular(TypeList typeList) async {
    var productss = await getProductsByType(typeList);
    return productss.where((element) => element.isPopular).toList();
  }

  Future<List<ProductItem>> getProductsByNewest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.createdDate.compareTo(b.createdDate));
    return productList;
  }

  Future<List<ProductItem>> getProductsByReview(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
    return productList;
  }

  Future<List<ProductItem>> getProductsByLowest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((a, b) => a.price.compareTo(b.price));
    return productList;
  }

  Future<List<ProductItem>> getProductsByHighest(TypeList typeList) async {
    var productList = await getProductsByType(typeList);
    productList.sort((b, a) => a.price.compareTo(b.price));
    return productList;
  }

  Future<List<ProductItem>> getProductsByName(
      TypeList typeList, String searchName) async {
    var productss = await getProductsByType(typeList);
    return productss
        .where((element) =>
            element.title.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }

  Future<List<ProductItem>> getProductsByCategory(
      TypeList typeList, String categoryName) async {
    var productss = await getProductsByType(typeList);
    return productss
        .where((element) => element.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }
}
