import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../repositories/features/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required this.categoryRepository})
      : super(const CategoryState()) {
    categoryLoaded();
  }

  final CategoryRepository categoryRepository;
  void categoryLoaded() async {
    try {
      if (state.status == CategoryStatus.initial) {
        emit(state.copyWith(status: CategoryStatus.loading));
        final categories = await categoryRepository.getCategories();
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
          await categoryRepository.getCategoriesByName(searchInput);
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
