part of 'product_bloc.dart';

enum ProductStatus { initial, success, failure, loading }
enum ChooseSort { popular, newest, review, priceLowest, priceHighest }

class ProductState extends Equatable {
  const ProductState(
      {this.categoryName = "All products",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.productList = const <ProductItem>[],
      this.status = ProductStatus.initial});
  final List<ProductItem> productList;
  final ProductStatus status;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isSearch;
  final String categoryName;

  ProductState copyWith(
      {ProductStatus? status,
      List<ProductItem>? productList,
      bool? isGridLayout,
      ChooseSort? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName}) {
    return ProductState(
        status: status ?? this.status,
        productList: productList ?? this.productList,
        isGridLayout: isGridLayout ?? this.isGridLayout,
        sort: sort ?? this.sort,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        categoryName: categoryName ?? this.categoryName);
  }

  @override
  List<Object> get props => [
        productList,
        status,
        isGridLayout,
        sort,
        searchInput,
        isSearch,
        categoryName
      ];
}
