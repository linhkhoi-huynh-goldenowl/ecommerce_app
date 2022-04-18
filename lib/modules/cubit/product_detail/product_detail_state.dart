part of 'product_detail_cubit.dart';

enum RelatedStatus { initial, loading, success, failure }
enum SizeStatus { initial, selected, unselected }

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.size = "",
      this.color = "",
      this.relatedList = const <ProductItem>[],
      this.relatedStatus = RelatedStatus.initial,
      this.sizeStatus = SizeStatus.initial});
  final String size;
  final String color;
  final RelatedStatus relatedStatus;
  final List<ProductItem> relatedList;
  final SizeStatus sizeStatus;
  ProductDetailState copyWith(
      {String? size,
      String? color,
      List<ProductItem>? relatedList,
      RelatedStatus? relatedStatus,
      SizeStatus? sizeStatus}) {
    return ProductDetailState(
        size: size ?? this.size,
        color: color ?? this.color,
        relatedList: relatedList ?? this.relatedList,
        relatedStatus: relatedStatus ?? this.relatedStatus,
        sizeStatus: sizeStatus ?? this.sizeStatus);
  }

  @override
  List<Object> get props =>
      [color, size, relatedList, relatedStatus, sizeStatus];
}
