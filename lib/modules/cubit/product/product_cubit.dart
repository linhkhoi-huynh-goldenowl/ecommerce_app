import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_item.dart';
import '../../repositories/x_result.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState()) {
    productLoaded();
  }
  StreamSubscription? productSubscription;
  void productLoaded() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final Stream<XResult<List<ProductItem>>> productsStream =
          Domain().product.getProductsStream();

      productSubscription = productsStream.listen((event) {
        emit(state.copyWith(
            status: ProductStatus.success,
            productList: event.data,
            type: TypeList.all));
      });
      // emit(state.copyWith(status: ProductStatus.loading));
      // final products = await Domain().product.getProducts();
      // emit(state.copyWith(
      //     status: ProductStatus.success,
      //     productList: products,
      //     type: TypeList.all));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  @override
  Future<void> close() {
    productSubscription?.cancel();
    return super.close();
  }

  void productNewLoaded() async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final products = await Domain().product.getProductsNew(state.productList);
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
          await Domain().product.getProductsSale(state.productList);
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
          await Domain().product.getProductsByName(state.type, searchName);
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
      emit(state.copyWith(status: ProductStatus.loading));
      emit(state.copyWith(
          isSearch: !state.isSearch, status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  void productCategoryEvent(String categoryName) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      if (categoryName == "All products" ||
          categoryName == state.categoryName) {
        var products = await Domain().product.getProductsByType(state.type);

        emit(state.copyWith(
            categoryName: "All products",
            productList: products,
            type: state.type,
            status: ProductStatus.success));
      } else {
        var products = await Domain()
            .product
            .getProductsByCategory(state.type, categoryName);

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
      var products = await Domain().product.getProducts();
      switch (chooseSort) {
        case ChooseSort.popular:
          products = await Domain().product.getProductsByPopular(state.type);
          break;
        case ChooseSort.newest:
          products = await Domain().product.getProductsByNewest(state.type);
          break;

        case ChooseSort.review:
          products = await Domain().product.getProductsByReview(state.type);
          break;
        case ChooseSort.priceLowest:
          products = await Domain().product.getProductsByLowest(state.type);
          break;
        case ChooseSort.priceHighest:
          products = await Domain().product.getProductsByHighest(state.type);
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
