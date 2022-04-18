part of 'product_cubit.dart';

enum ProductStatus {
  initial,
  success,
  failure,
  loading,
}

enum TypeList { all, newest, sale }
enum GridProductStatus { initialGrid, loadingGrid, successGrid, failureGrid }
enum SearchProductStatus {
  initialSearch,
  loadingSearch,
  successSearch,
  failureSearch
}

enum ChooseSort { popular, newest, review, priceLowest, priceHighest }

class ProductState extends Equatable {
  const ProductState(
      {this.gridStatus = GridProductStatus.initialGrid,
      this.searchStatus = SearchProductStatus.initialSearch,
      this.categoryName = "",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.productList = const <ProductItem>[],
      this.status = ProductStatus.initial,
      this.type = TypeList.all,
      this.isShowCategoryBar = true});
  final List<ProductItem> productList;
  final ProductStatus status;
  final GridProductStatus gridStatus;
  final SearchProductStatus searchStatus;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isShowCategoryBar;
  final bool isSearch;
  final String categoryName;
  final TypeList type;

  ProductState copyWith(
      {ProductStatus? status,
      List<ProductItem>? productList,
      bool? isGridLayout,
      ChooseSort? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName,
      GridProductStatus? gridStatus,
      SearchProductStatus? searchStatus,
      TypeList? type,
      bool? isShowCategoryBar}) {
    return ProductState(
        status: status ?? this.status,
        productList: productList ?? this.productList,
        isGridLayout: isGridLayout ?? this.isGridLayout,
        sort: sort ?? this.sort,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        categoryName: categoryName ?? this.categoryName,
        gridStatus: gridStatus ?? this.gridStatus,
        searchStatus: searchStatus ?? this.searchStatus,
        type: type ?? this.type,
        isShowCategoryBar: isShowCategoryBar ?? this.isShowCategoryBar);
  }

  @override
  List<Object> get props => [
        productList,
        status,
        isGridLayout,
        sort,
        searchInput,
        isSearch,
        categoryName,
        gridStatus,
        searchStatus,
        type,
        isShowCategoryBar
      ];
}
