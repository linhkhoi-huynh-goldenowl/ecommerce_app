import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

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
      emit(state.copyWith(isSearch: !state.isSearch));
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }
}
