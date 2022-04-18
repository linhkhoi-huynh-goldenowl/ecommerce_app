part of 'favorite_cubit.dart';

enum FavoriteStatus {
  initial,
  success,
  failure,
  loading,
}
enum GridFavoriteStatus { initialGrid, loadingGrid, successGrid, failureGrid }
enum SearchFavoriteStatus {
  initialSearch,
  loadingSearch,
  successSearch,
  failureSearch
}

class FavoriteState extends Equatable {
  const FavoriteState(
      {this.gridStatus = GridFavoriteStatus.initialGrid,
      this.searchStatus = SearchFavoriteStatus.initialSearch,
      this.categoryName = "Favorites",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.favorites = const <FavoriteProduct>[],
      this.status = FavoriteStatus.initial,
      this.products = const <ProductItem>[]});
  final List<FavoriteProduct> favorites;
  final List<ProductItem> products;
  final FavoriteStatus status;
  final GridFavoriteStatus gridStatus;
  final SearchFavoriteStatus searchStatus;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isSearch;

  final String categoryName;

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteProduct>? favorites,
    bool? isGridLayout,
    ChooseSort? sort,
    bool? isSearch,
    String? searchInput,
    String? categoryName,
    GridFavoriteStatus? gridStatus,
    SearchFavoriteStatus? searchStatus,
    List<ProductItem>? products,
  }) {
    return FavoriteState(
        status: status ?? this.status,
        favorites: favorites ?? this.favorites,
        isGridLayout: isGridLayout ?? this.isGridLayout,
        sort: sort ?? this.sort,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        categoryName: categoryName ?? this.categoryName,
        gridStatus: gridStatus ?? this.gridStatus,
        searchStatus: searchStatus ?? this.searchStatus,
        products: products ?? this.products);
  }

  @override
  List<Object> get props => [
        favorites,
        status,
        isGridLayout,
        sort,
        searchInput,
        isSearch,
        categoryName,
        gridStatus,
        searchStatus,
        products
      ];
}
