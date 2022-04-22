import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';

import 'package:equatable/equatable.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState()) {
    categoryLoaded();
  }

  void categoryLoaded() async {
    try {
      if (state.status == CategoryStatus.initial) {
        emit(state.copyWith(status: CategoryStatus.loading));
        final categories = await Domain().category.getCategories();
        emit(state.copyWith(
            status: CategoryStatus.success, categories: categories));
      }
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }

  void categorySearch(String searchInput) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      final categories =
          await Domain().category.getCategoriesByName(searchInput);
      emit(state.copyWith(
          status: CategoryStatus.success,
          categories: categories,
          searchInput: searchInput));
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }

  void categoryOpenSearchBar() async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      emit(state.copyWith(
          isSearch: !state.isSearch, status: CategoryStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }
}
