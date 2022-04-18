part of 'product_detail_cubit.dart';

enum RelatedStatus { initial, loading, success, failure }
enum SizeStatus { initial, selected, unselected }

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.size = "",
      this.color = "",
      this.relatedList = const <ProductItem>[],
      this.relatedStatus = RelatedStatus.initial,
      this.sizeStatus = SizeStatus.initial,
      this.reviewStars = 0,
      this.numReview = 0});
  final String size;
  final String color;
  final int reviewStars;
  final int numReview;
  final RelatedStatus relatedStatus;
  final List<ProductItem> relatedList;
  final SizeStatus sizeStatus;
  ProductDetailState copyWith(
      {String? size,
      String? color,
      List<ProductItem>? relatedList,
      RelatedStatus? relatedStatus,
      SizeStatus? sizeStatus,
      int? reviewStars,
      int? numReview}) {
    return ProductDetailState(
        size: size ?? this.size,
        color: color ?? this.color,
        relatedList: relatedList ?? this.relatedList,
        relatedStatus: relatedStatus ?? this.relatedStatus,
        sizeStatus: sizeStatus ?? this.sizeStatus,
        numReview: numReview ?? this.numReview,
        reviewStars: reviewStars ?? this.reviewStars);
  }

  @override
  List<Object> get props => [
        color,
        size,
        relatedList,
        relatedStatus,
        sizeStatus,
        reviewStars,
        numReview
      ];
}
