import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_item.dart';
import '../../repositories/features/repository/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.productRepository})
      : super(const ProductState()) {
    productLoaded();
  }

  final ProductRepository productRepository;

  void productLoaded() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products = await productRepository.getProducts();
      emit(state.copyWith(
          status: ProductStatus.success,
          productList: products,
          type: TypeList.all));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productNewLoaded() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products =
          await productRepository.getProductsNew(state.productList);
      emit(state.copyWith(
          status: ProductStatus.success,
          productList: products,
          type: TypeList.newest));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productSaleLoaded() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products =
          await productRepository.getProductsSale(state.productList);
      emit(state.copyWith(
          status: ProductStatus.success,
          productList: products,
          type: TypeList.sale));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productLoadGridLayout() async {
    try {
      emit(state.copyWith(
          gridStatus: GridProductStatus.loadingGrid,
          status: ProductStatus.loading));
      emit(state.copyWith(
          isGridLayout: !state.isGridLayout,
          gridStatus: GridProductStatus.successGrid,
          status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridProductStatus.failureGrid));
    }
  }

  void productSearchEvent(String searchName) async {
    try {
      emit(state.copyWith(
          searchStatus: SearchProductStatus.loadingSearch,
          status: ProductStatus.loading));
      var products =
          await productRepository.getProductsByName(state.type, searchName);
      emit(state.copyWith(
          productList: products,
          searchStatus: SearchProductStatus.successSearch,
          searchInput: searchName,
          status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(searchStatus: SearchProductStatus.failureSearch));
    }
  }

  void productOpenSearchBarEvent() async {
    try {
      emit(state.copyWith(isSearch: !state.isSearch));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productCategoryEvent(String categoryName) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      if (categoryName == "All products" ||
          categoryName == state.categoryName) {
        var products = await productRepository.getProductsByType(state.type);

        emit(state.copyWith(
            categoryName: "All products",
            productList: products,
            type: state.type,
            status: ProductStatus.success));
      } else {
        var products = await productRepository.getProductsByCategory(
            state.type, categoryName);

        emit(state.copyWith(
            categoryName: categoryName,
            productList: products,
            type: state.type,
            status: ProductStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productSort(ChooseSort chooseSort) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      var products = await productRepository.getProducts();
      switch (chooseSort) {
        case ChooseSort.popular:
          products = await productRepository.getProductsByPopular(state.type);
          break;
        case ChooseSort.newest:
          products = await productRepository.getProductsByNewest(state.type);
          break;

        case ChooseSort.review:
          products = await productRepository.getProductsByReview(state.type);
          break;
        case ChooseSort.priceLowest:
          products = await productRepository.getProductsByLowest(state.type);
          break;
        case ChooseSort.priceHighest:
          products = await productRepository.getProductsByHighest(state.type);
          break;
      }
      emit(state.copyWith(
          sort: chooseSort,
          productList: products,
          status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
