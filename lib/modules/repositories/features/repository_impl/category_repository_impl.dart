import 'package:e_commerce_shop_app/modules/repositories/features/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  List<String> categories = <String>[
    "Tops",
    "Shirts & Blouses",
    "Cardigans & Sweaters",
    "Knitwear",
    "Blazers",
    "Outerwear",
    "Pants",
    "Jeans",
    "Shorts",
    "Skirts",
    "Dresses"
  ];
  @override
  Future<List<String>> getCategories() async {
    return categories;
  }

  @override
  Future<List<String>> getCategoriesByName(String searchName) async {
    return categories
        .where((element) =>
            element.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }
}
