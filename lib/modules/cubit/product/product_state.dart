part of 'product_cubit.dart';

enum ProductStatus {
  initial,
  success,
  failure,
  loading,
}
enum ProductNewStatus {
  initial,
  success,
  failure,
  loading,
}

enum ProductSaleStatus {
  initial,
  success,
  failure,
  loading,
}

enum TypeList { all, newest, sale }

enum ChooseSort { popular, newest, review, priceLowest, priceHighest }

class ProductState extends Equatable {
  const ProductState(
      {this.categoryName = "",
      this.searchInput = "",
      this.isSearch = false,
      this.sort = ChooseSort.newest,
      this.isGridLayout = false,
      this.productList = const <ProductItem>[],
      this.productNewList = const <ProductItem>[],
      this.productSaleList = const <ProductItem>[],
      this.status = ProductStatus.initial,
      this.statusNew = ProductNewStatus.initial,
      this.statusSale = ProductSaleStatus.initial,
      this.type = TypeList.all,
      this.isShowCategoryBar = true,
      this.errMessage = ""});
  final List<ProductItem> productList;
  final List<ProductItem> productNewList;
  final List<ProductItem> productSaleList;

  List<ProductItem> get productListToShow {
    List<ProductItem> productFilter;
    switch (type) {
      case TypeList.all:
        productFilter = productList;
        break;
      case TypeList.newest:
        productFilter = productNewList;
        break;

      case TypeList.sale:
        productFilter = productSaleList;
        break;
    }

    productFilter = productFilter
        .where((element) =>
            element.title.toLowerCase().contains(searchInput.toLowerCase()))
        .toList();
    if (categoryName != "") {
      productFilter = productFilter
          .where((element) => element.categoryName
              .toLowerCase()
              .contains(categoryName.toLowerCase()))
          .toList();
    }
    switch (sort) {
      case ChooseSort.popular:
        productFilter =
            productFilter.where((element) => element.isPopular).toList();
        break;
      case ChooseSort.newest:
        var productsNews = productFilter;
        productsNews.sort(
            (b, a) => a.createdDate.toDate().compareTo(b.createdDate.toDate()));
        productFilter = productsNews;
        break;

      case ChooseSort.review:
        var productsReview = productFilter;
        productsReview.sort((b, a) => a.reviewStars.compareTo(b.reviewStars));
        productFilter = productsReview;
        break;
      case ChooseSort.priceLowest:
        var productsLow = productFilter;
        productsLow.sort((a, b) =>
            a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
        productFilter = productsLow;
        break;
      case ChooseSort.priceHighest:
        var productsHigh = productFilter;
        productsHigh.sort((b, a) =>
            a.colors[0].sizes[0].price.compareTo(b.colors[0].sizes[0].price));
        productFilter = productsHigh;
        break;
    }

    return productFilter;
  }

  final ProductStatus status;
  final ProductNewStatus statusNew;
  final ProductSaleStatus statusSale;
  final bool isGridLayout;
  final ChooseSort sort;
  final String searchInput;
  final bool isShowCategoryBar;
  final bool isSearch;
  final String categoryName;
  final TypeList type;
  final String errMessage;

  ProductState copyWith(
      {ProductStatus? status,
      ProductNewStatus? statusNew,
      ProductSaleStatus? statusSale,
      List<ProductItem>? productList,
      List<ProductItem>? productNewList,
      List<ProductItem>? productSaleList,
      bool? isGridLayout,
      ChooseSort? sort,
      bool? isSearch,
      String? searchInput,
      String? categoryName,
      TypeList? type,
      bool? isShowCategoryBar,
      String? errMessage}) {
    return ProductState(
        status: status ?? this.status,
        statusNew: statusNew ?? this.statusNew,
        statusSale: statusSale ?? this.statusSale,
        productList: productList ?? this.productList,
        productNewList: productNewList ?? this.productNewList,
        productSaleList: productSaleList ?? this.productSaleList,
        isGridLayout: isGridLayout ?? this.isGridLayout,
        sort: sort ?? this.sort,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        categoryName: categoryName ?? this.categoryName,
        type: type ?? this.type,
        isShowCategoryBar: isShowCategoryBar ?? this.isShowCategoryBar,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object> get props => [
        productList,
        productNewList,
        productSaleList,
        status,
        isGridLayout,
        sort,
        searchInput,
        isSearch,
        categoryName,
        type,
        errMessage,
        isShowCategoryBar,
        statusNew,
        statusSale
      ];
}
