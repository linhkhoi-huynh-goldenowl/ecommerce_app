part of 'product_detail_cubit.dart';

enum RelatedStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.size = "",
      this.color = "",
      this.relatedList = const <ProductItem>[],
      this.relatedStatus = RelatedStatus.initial});
  final String size;
  final String color;
  final RelatedStatus relatedStatus;
  final List<ProductItem> relatedList;

  ProductDetailState copyWith(
      {String? size,
      String? color,
      List<ProductItem>? relatedList,
      RelatedStatus? relatedStatus}) {
    return ProductDetailState(
        size: size ?? this.size,
        color: color ?? this.color,
        relatedList: relatedList ?? this.relatedList,
        relatedStatus: relatedStatus ?? this.relatedStatus);
  }

  @override
  List<Object> get props => [color, size, relatedList, relatedStatus];
}
