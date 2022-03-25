class CategoryRepository {
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
  Future<List<String>> getCategories() async {
    return categories;
  }

  Future<List<String>> getCategoriesByName(String searchName) async {
    return categories
        .where((element) =>
            element.toLowerCase().contains(searchName.toLowerCase()))
        .toList();
  }
}
