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
        Domain().product.setProducts(event.data ?? []);
        final products = Domain().product.getProducts();
        emit(state.copyWith(
            status: ProductStatus.success,
            productList: products,
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

  void productOpenSearchBarEvent() async {
    try {
      emit(state.copyWith(gridStatus: GridProductStatus.loadingGrid));
      emit(state.copyWith(
          isSearch: !state.isSearch,
          gridStatus: GridProductStatus.successGrid));
    } catch (_) {
      emit(state.copyWith(gridStatus: GridProductStatus.failureGrid));
    }
  }

  void productOpenCategoryBarEvent() async {
    try {
      emit(state.copyWith(
          gridStatus: GridProductStatus.loadingGrid,
          status: ProductStatus.loading));
      emit(state.copyWith(
          isShowCategoryBar: !state.isShowCategoryBar,
          gridStatus: GridProductStatus.successGrid,
          status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(
          gridStatus: GridProductStatus.failureGrid,
          status: ProductStatus.failure));
    }
  }

  void productSort(
      {String? searchName,
      TypeList? typeList,
      ChooseSort? chooseSort,
      String? categoryName}) async {
    try {
      emit(state.copyWith(gridStatus: GridProductStatus.loadingGrid));

      if (categoryName == state.categoryName) {
        var products = await Domain().product.getProductsFilter(
            searchName: searchName ?? state.searchInput,
            chooseSort: chooseSort ?? state.sort,
            typeList: typeList ?? state.type);

        emit(state.copyWith(
            sort: chooseSort ?? state.sort,
            categoryName: "",
            searchInput: searchName ?? state.searchInput,
            type: typeList ?? state.type,
            productList: products,
            gridStatus: GridProductStatus.successGrid));
      } else {
        var products = await Domain().product.getProductsFilter(
            searchName: searchName ?? state.searchInput,
            categoryName: categoryName ?? state.categoryName,
            chooseSort: chooseSort ?? state.sort,
            typeList: typeList ?? state.type);
        emit(state.copyWith(
            sort: chooseSort ?? state.sort,
            categoryName: categoryName ?? state.categoryName,
            searchInput: searchName ?? state.searchInput,
            type: typeList ?? state.type,
            productList: products,
            gridStatus: GridProductStatus.successGrid));
      }
    } catch (_) {
      emit(state.copyWith(gridStatus: GridProductStatus.failureGrid));
    }
  }
}
