part of 'favorite_cubit.dart';

enum FavoriteStatus {
  initial,
  success,
  failure,
  loading,
}

enum AddFavoriteStatus {
  initial,
  success,
  failure,
  loading,
}

class FavoriteState extends Equatable {
  const FavoriteState(
      {this.categoryName = "",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.favorites = const <FavoriteProduct>[],
      this.status = FavoriteStatus.initial,
      this.products = const <ProductItem>[],
      this.isShowCategoryBar = true,
      this.errMessage = "",
      this.tagsFilter = const [],
      this.addStatus = AddFavoriteStatus.initial});
  final List<FavoriteProduct> favorites;

  List<FavoriteProduct> get favoritesListToShow {
    List<FavoriteProduct> favoritesList = favorites;
    favoritesList = FavoriteHelper.filterByName(searchInput, favoritesList);

    if (tagsFilter.isNotEmpty) {
      favoritesList = FavoriteHelper.filterByTag(tagsFilter, favoritesList);
    }

    if (categoryName != "") {
      favoritesList =
          FavoriteHelper.sortByCategory(categoryName, favoritesList);
    }
    favoritesList = FavoriteHelper.sortByTypeFavorite(sort, favoritesList);

    return favoritesList;
  }

  final List<ProductItem> products;
  final FavoriteStatus status;
  final AddFavoriteStatus addStatus;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isSearch;
  final bool isShowCategoryBar;
  final String categoryName;
  final String errMessage;
  final List<TagModel> tagsFilter;
  FavoriteState copyWith(
      {FavoriteStatus? status,
      List<FavoriteProduct>? favorites,
      bool? isGridLayout,
      ChooseSort? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName,
      List<ProductItem>? products,
      bool? isShowCategoryBar,
      String? errMessage,
      List<TagModel>? tagsFilter,
      AddFavoriteStatus? addStatus}) {
    return FavoriteState(
        status: status ?? this.status,
        favorites: favorites ?? this.favorites,
        isGridLayout: isGridLayout ?? this.isGridLayout,
        sort: sort ?? this.sort,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        categoryName: categoryName ?? this.categoryName,
        products: products ?? this.products,
        isShowCategoryBar: isShowCategoryBar ?? this.isShowCategoryBar,
        errMessage: errMessage ?? this.errMessage,
        tagsFilter: tagsFilter ?? this.tagsFilter,
        addStatus: addStatus ?? this.addStatus);
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
        products,
        isShowCategoryBar,
        errMessage,
        tagsFilter,
        addStatus
      ];
}
