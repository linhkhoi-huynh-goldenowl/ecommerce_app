import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/modules/models/product_item.dart';
import 'package:ecommerce_app/modules/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductState()) {
    on<ProductLoadedEvent>(_onProductLoaded);
    on<ProductLoadGridLayoutEvent>(_onProductLoadGridLayout);
    on<ProductSortEvent>(_onProductSort);
    on<ProductSearchEvent>(_onProductSearchEvent);
    on<ProductOpenSearchBarEvent>(_onProductOpenSearchBarEvent);
    on<ProductCategoryEvent>(_onProductCategoryEvent);
  }
  final ProductRepository _productRepository;

  Future<void> _onProductLoaded(
    ProductLoadedEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state.status == ProductStatus.initial) {
        emit(state.copyWith(status: ProductStatus.loading));
        final products = await _productRepository.getProducts();
        emit(state.copyWith(
            status: ProductStatus.success, productList: products));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductLoadGridLayout(
    ProductLoadGridLayoutEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(isGridLayout: !state.isGridLayout));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductSearchEvent(
    ProductSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      var products =
          await _productRepository.getProductsByName(event.searchName);
      emit(state.copyWith(
          productList: products,
          status: ProductStatus.success,
          searchInput: event.searchName));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductOpenSearchBarEvent(
    ProductOpenSearchBarEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(isSearch: !state.isSearch));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductCategoryEvent(
    ProductCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (event.categoryName == "All products" ||
          event.categoryName == state.categoryName) {
        var products = await _productRepository.getProducts();
        emit(state.copyWith(
            categoryName: "All products", productList: products));
      } else {
        var products =
            await _productRepository.getProductsByCategory(event.categoryName);
        emit(state.copyWith(
            categoryName: event.categoryName, productList: products));
      }
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<void> _onProductSort(
    ProductSortEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProductStatus.loading));
      var products = await _productRepository.getProducts();
      switch (event.sort) {
        case ChooseSort.popular:
          products = await _productRepository.getProductsByPopular();
          break;
        case ChooseSort.newest:
          products = await _productRepository.getProductsByNewest();
          break;

        case ChooseSort.review:
          products = await _productRepository.getProductsByReview();
          break;
        case ChooseSort.priceLowest:
          products = await _productRepository.getProductsByLowest();
          break;
        case ChooseSort.priceHighest:
          products = await _productRepository.getProductsByHighest();
          break;
      }
      emit(state.copyWith(
          sort: event.sort,
          productList: products,
          status: ProductStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
