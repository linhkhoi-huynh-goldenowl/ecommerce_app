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

enum AddCartStatus {
  initial,
  success,
  failure,
  loading,
}

class FavoriteState extends Equatable {
  const FavoriteState(
      {this.gridStatus = GridFavoriteStatus.initialGrid,
      this.searchStatus = SearchFavoriteStatus.initialSearch,
      this.categoryName = "",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.favorites = const <FavoriteProduct>[],
      this.status = FavoriteStatus.initial,
      this.products = const <ProductItem>[],
      this.isShowCategoryBar = true,
      this.errMessage = "",
      this.addCartStatus = AddCartStatus.initial});
  final List<FavoriteProduct> favorites;

  List<FavoriteProduct> get favoritesListToShow {
    List<FavoriteProduct> favoritesList = favorites;
    favoritesList = favoritesList
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(searchInput.toLowerCase()))
        .toList();
    if (categoryName != "") {
      favoritesList = favoritesList
          .where((element) => element.productItem.categoryName
              .toLowerCase()
              .contains(categoryName.toLowerCase()))
          .toList();
    }
    switch (sort) {
      case ChooseSort.popular:
        {
          favoritesList = favoritesList
              .where((element) => element.productItem.isPopular)
              .toList();
          break;
        }
      case ChooseSort.newest:
        {
          var favoritesNews = favoritesList;
          favoritesNews.sort((b, a) => a.productItem.createdDate
              .toDate()
              .compareTo(b.productItem.createdDate.toDate()));
          favoritesList = favoritesNews;
          break;
        }

      case ChooseSort.review:
        {
          var favoritesReview = favoritesList;
          favoritesReview.sort((b, a) =>
              a.productItem.reviewStars.compareTo(b.productItem.reviewStars));
          favoritesList = favoritesReview;
          break;
        }
      case ChooseSort.priceLowest:
        {
          var favoritesLow = favoritesList;
          favoritesLow.sort((a, b) => a.productItem.colors[0].sizes[0].price
              .compareTo(b.productItem.colors[0].sizes[0].price));
          favoritesList = favoritesLow;
          break;
        }
      case ChooseSort.priceHighest:
        {
          var favoritesHigh = favoritesList;
          favoritesHigh.sort((b, a) => a.productItem.colors[0].sizes[0].price
              .compareTo(b.productItem.colors[0].sizes[0].price));
          favoritesList = favoritesHigh;
          break;
        }
    }

    return favoritesList;
  }

  final List<ProductItem> products;
  final FavoriteStatus status;
  final GridFavoriteStatus gridStatus;
  final SearchFavoriteStatus searchStatus;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isSearch;
  final bool isShowCategoryBar;
  final String categoryName;
  final String errMessage;
  final AddCartStatus addCartStatus;

  FavoriteState copyWith(
      {FavoriteStatus? status,
      List<FavoriteProduct>? favorites,
      bool? isGridLayout,
      ChooseSort? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName,
      GridFavoriteStatus? gridStatus,
      SearchFavoriteStatus? searchStatus,
      List<ProductItem>? products,
      bool? isShowCategoryBar,
      String? errMessage,
      AddCartStatus? addCartStatus}) {
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
        products: products ?? this.products,
        isShowCategoryBar: isShowCategoryBar ?? this.isShowCategoryBar,
        errMessage: errMessage ?? this.errMessage,
        addCartStatus: addCartStatus ?? this.addCartStatus);
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
        products,
        isShowCategoryBar,
        errMessage,
        addCartStatus
      ];
}
