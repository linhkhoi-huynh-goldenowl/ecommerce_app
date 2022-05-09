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
  const ProductState({
    this.categoryName = "",
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
    this.errMessage = "",
    this.tagsFilter = const [],
  });
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

    if (tagsFilter.isNotEmpty) {
      productFilter = ProductHelper.filterByTag(tagsFilter, productFilter);
    }

    productFilter = ProductHelper.filterByName(searchInput, productFilter);
    if (categoryName != "") {
      productFilter = ProductHelper.sortByCategory(categoryName, productFilter);
    }
    productFilter = ProductHelper.sortByTypeProduct(sort, productFilter);

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

  final List<TagModel> tagsFilter;

  ProductState copyWith({
    ProductStatus? status,
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
    String? errMessage,
    List<TagModel>? tagsFilter,
  }) {
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
      errMessage: errMessage ?? this.errMessage,
      tagsFilter: tagsFilter ?? this.tagsFilter,
    );
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
        statusSale,
        tagsFilter,
      ];
}
