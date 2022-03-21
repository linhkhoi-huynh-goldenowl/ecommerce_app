import 'package:ecommerce_app/modules/models/product_item.dart';

class ProductRepository {
  List<ProductItem> products = <ProductItem>[
    ProductItem("SWE", "assets/images/sale_product1.png", 25, 12, 4,
        "T-shirt winter", DateTime.utc(2022, 1, 24), true, "Tops"),
    ProductItem("Addidas", "assets/images/sale_product2.png", 11, 4, 5,
        "Brown Paint", DateTime.utc(2021, 4, 21), false, "Shirts & Blouses"),
    ProductItem("Dirty Coins", "assets/images/sale_product3.png", 25, 5, 5,
        "Red Dress flower", DateTime.utc(2021, 5, 11), false, "Tops"),
    ProductItem("Degrey", "assets/images/sale_product4.png", 35, 13, 3,
        "Wind jacket", DateTime.utc(2022, 2, 23), false, "Knitwear"),
    ProductItem("Now", "assets/images/sale_product5.png", 23, 44, 1,
        "Hoodie Full", DateTime.utc(2021, 5, 5), false, "Tops"),
    ProductItem("Puma", "assets/images/sale_product6.png", 11, 23, 4,
        "Grid short", DateTime.utc(2020, 12, 11), false, "Jeans"),
    ProductItem("Crownz", "assets/images/sale_product7.png", 64, 16, 5,
        "Anna shirt", DateTime.utc(2019, 2, 4), true, "Skirts"),
    ProductItem("Bitis", "assets/images/sale_product8.png", 35, 6, 2,
        "New Skirt", DateTime.utc(2022, 1, 27), true, "Shorts"),
    ProductItem("Samsung", "assets/images/sale_product9.png", 6, 66, 2,
        "Satin Paint", DateTime.utc(2021, 10, 17), false, "Skirts"),
    ProductItem("Apple", "assets/images/sale_product10.png", 12, 4, 5,
        "T-shirt Hard", DateTime.utc(2021, 9, 9), true, "Dresses"),
  ];
  Future<List<ProductItem>> getProducts() async {
    return products;
  }

  Future<List<ProductItem>> getProductsByPopular() async {
    return products.where((element) => element.isPopular).toList();
  }

  Future<List<ProductItem>> getProductsByNewest() async {
    var productList = products;
    productList.sort((b, a) => a.createdDate.compareTo(b.createdDate));
    return productList;
  }

  Future<List<ProductItem>> getProductsByReview() async {
    var productList = products;
    productList.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
    return productList;
  }

  Future<List<ProductItem>> getProductsByLowest() async {
    var productList = products;
    productList.sort((a, b) => a.price.compareTo(b.price));
    return productList;
  }

  Future<List<ProductItem>> getProductsByHighest() async {
    var productList = products;
    productList.sort((b, a) => a.price.compareTo(b.price));
    return productList;
  }

  Future<List<ProductItem>> getProductsByName(String searchName) async {
    return products
        .where((element) =>
            element.title.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }

  Future<List<ProductItem>> getProductsByCategory(String categoryName) async {
    return products
        .where((element) => element.categoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
  }
}
