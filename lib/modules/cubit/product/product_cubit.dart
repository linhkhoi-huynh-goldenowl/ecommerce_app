import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_item.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.productRepository})
      : super(const ProductState()) {
    productLoaded();
  }

  final ProductRepository productRepository;

  void productLoaded() async {
    try {
      if (state.status == ProductStatus.initial) {
        emit(state.copyWith(status: ProductStatus.loading));
        final products = await productRepository.getProducts();
        emit(state.copyWith(
            status: ProductStatus.success, productList: products));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productLoadGridLayout() async {
    try {
      emit(state.copyWith(gridStatus: GridProductStatus.loadingGrid));
      emit(state.copyWith(
          isGridLayout: !state.isGridLayout,
          gridStatus: GridProductStatus.successGrid));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridProductStatus.failureGrid));
    }
  }

  void productSearchEvent(String searchName) async {
    try {
      emit(state.copyWith(searchStatus: SearchProductStatus.loadingSearch));
      var products = await productRepository.getProductsByName(searchName);
      emit(state.copyWith(
          productList: products,
          searchStatus: SearchProductStatus.successSearch,
          searchInput: searchName));
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
      if (categoryName == "All products" ||
          categoryName == state.categoryName) {
        var products = await productRepository.getProducts();
        emit(state.copyWith(
            categoryName: "All products", productList: products));
      } else {
        var products =
            await productRepository.getProductsByCategory(categoryName);
        emit(state.copyWith(categoryName: categoryName, productList: products));
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
          products = await productRepository.getProductsByPopular();
          break;
        case ChooseSort.newest:
          products = await productRepository.getProductsByNewest();
          break;

        case ChooseSort.review:
          products = await productRepository.getProductsByReview();
          break;
        case ChooseSort.priceLowest:
          products = await productRepository.getProductsByLowest();
          break;
        case ChooseSort.priceHighest:
          products = await productRepository.getProductsByHighest();
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
