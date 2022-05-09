import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../models/product_item.dart';
import '../../repositories/x_result.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState()) {
    fetchProducts();
    fetchProductsNew();
    fetchProductsSale();
  }
  StreamSubscription? productSubscription;
  StreamSubscription? productSaleSubscription;
  StreamSubscription? productNewSubscription;
  @override
  Future<void> close() {
    productSubscription?.cancel();
    productSaleSubscription?.cancel();
    productNewSubscription?.cancel();
    return super.close();
  }

  void fetchProducts() {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      final Stream<XResult<List<ProductItem>>> productsStream =
          Domain().product.getProductsStream();

      productSubscription = productsStream.listen((event) {
        emit(state.copyWith(status: ProductStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              status: ProductStatus.success,
              productList: event.data,
              type: TypeList.all,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: ProductStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: ProductStatus.failure, errMessage: "Something wrong"));
    }
  }

  void fetchProductsNew() {
    try {
      emit(state.copyWith(statusNew: ProductNewStatus.loading));
      final Stream<XResult<List<ProductItem>>> productsNewStream =
          Domain().product.getProductsNewStream();

      productNewSubscription = productsNewStream.listen((event) {
        emit(state.copyWith(statusNew: ProductNewStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              statusNew: ProductNewStatus.success,
              productNewList: event.data,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              statusNew: ProductNewStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          statusNew: ProductNewStatus.failure, errMessage: "Something wrong"));
    }
  }

  void fetchProductsSale() {
    try {
      emit(state.copyWith(statusSale: ProductSaleStatus.loading));
      final Stream<XResult<List<ProductItem>>> productsSaleStream =
          Domain().product.getProductsSaleStream();
      productSaleSubscription = productsSaleStream.listen((event) {
        emit(state.copyWith(statusSale: ProductSaleStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              statusSale: ProductSaleStatus.success,
              productSaleList: event.data,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              statusSale: ProductSaleStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          statusSale: ProductSaleStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void productSetType(TypeList typeList) async {
    emit(state.copyWith(type: typeList));
  }

  void productLoadGridLayout() async {
    emit(state.copyWith(isGridLayout: !state.isGridLayout));
  }

  void productOpenSearchBarEvent() async {
    emit(state.copyWith(isSearch: !state.isSearch));
  }

  void productOpenCategoryBarEvent() async {
    emit(state.copyWith(
      isShowCategoryBar: !state.isShowCategoryBar,
    ));
  }

  void productSearch(String searchName) {
    emit(state.copyWith(searchInput: searchName));
  }

  void filterProductCategory(String categoryName) {
    if (categoryName == state.categoryName) {
      emit(state.copyWith(categoryName: ""));
    } else {
      emit(state.copyWith(categoryName: categoryName));
    }
  }

  void filterProductType(ChooseSort chooseSort) {
    emit(state.copyWith(sort: chooseSort));
  }
}
