part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductLoadedEvent extends ProductEvent {}

class ProductLoadGridLayoutEvent extends ProductEvent {}

class ProductSortEvent extends ProductEvent {
  final ChooseSort sort;
  const ProductSortEvent({required this.sort});
}

class ProductOpenSearchBarEvent extends ProductEvent {
  const ProductOpenSearchBarEvent();
}

class ProductCategoryEvent extends ProductEvent {
  final String categoryName;
  const ProductCategoryEvent({required this.categoryName});
}

class ProductSearchEvent extends ProductEvent {
  final String searchName;
  const ProductSearchEvent({required this.searchName});
}
