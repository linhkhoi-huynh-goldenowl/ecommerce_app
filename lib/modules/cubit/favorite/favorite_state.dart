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

enum ChooseSortFavorite { popular, newest, review, priceLowest, priceHighest }

class FavoriteState extends Equatable {
  const FavoriteState(
      {this.gridStatus = GridFavoriteStatus.initialGrid,
      this.searchStatus = SearchFavoriteStatus.initialSearch,
      this.categoryName = "Favorites",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSortFavorite.newest,
      this.isGridLayout = false,
      this.favorites = const <FavoriteProduct>[],
      this.status = FavoriteStatus.initial,
      this.size = "",
      this.favoritesListSub = const <FavoriteProduct>[],
      this.useListSub = false});
  final List favorites;
  final FavoriteStatus status;
  final GridFavoriteStatus gridStatus;
  final SearchFavoriteStatus searchStatus;
  final bool isGridLayout;
  final ChooseSortFavorite sort;
  final String searchInput;
  final bool isSearch;
  //This is a sub list which use for filter or search
  final List favoritesListSub;
  final bool useListSub;
  final String categoryName;
  final String size;

  FavoriteState copyWith(
      {FavoriteStatus? status,
      List? favorites,
      bool? isGridLayout,
      ChooseSortFavorite? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName,
      List? favoritesListSub,
      bool? useListSub,
      GridFavoriteStatus? gridStatus,
      SearchFavoriteStatus? searchStatus,
      String? size}) {
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
        size: size ?? this.size,
        favoritesListSub: favoritesListSub ?? this.favoritesListSub,
        useListSub: useListSub ?? this.useListSub);
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
        size,
        favoritesListSub,
        useListSub
      ];
}
