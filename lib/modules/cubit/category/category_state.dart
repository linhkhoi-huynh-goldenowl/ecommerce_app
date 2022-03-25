part of 'category_cubit.dart';

enum CategoryStatus { initial, success, failure, loading }

class CategoryState extends Equatable {
  const CategoryState(
      {this.categories = const <String>[],
      this.status = CategoryStatus.initial,
      this.isSearch = false,
      this.searchInput = ""});
  final List<String> categories;
  final CategoryStatus status;
  final String searchInput;
  final bool isSearch;

  CategoryState copyWith(
      {CategoryStatus? status,
      List<String>? categories,
      bool? isSearch,
      String? searchInput}) {
    return CategoryState(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        isSearch: isSearch ?? this.isSearch,
        searchInput: searchInput ?? this.searchInput);
  }

  @override
  List<Object> get props => [categories, status, isSearch, searchInput];
}
