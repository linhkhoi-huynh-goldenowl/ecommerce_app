abstract class CategoryRepository {
  Future<List<String>> getCategories();

  Future<List<String>> getCategoriesByName(String searchName);
}
