part of 'product_detail_cubit.dart';

enum SizeStatus { initial, selected, unselected }

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.size = "",
      this.color = "",
      this.sizeStatus = SizeStatus.initial,
      this.reviewStars = 0,
      this.numReview = 0});
  final String size;
  final String color;
  final int reviewStars;
  final int numReview;
  final SizeStatus sizeStatus;
  ProductDetailState copyWith(
      {String? size,
      String? color,
      SizeStatus? sizeStatus,
      int? reviewStars,
      int? numReview}) {
    return ProductDetailState(
        size: size ?? this.size,
        color: color ?? this.color,
        sizeStatus: sizeStatus ?? this.sizeStatus,
        numReview: numReview ?? this.numReview,
        reviewStars: reviewStars ?? this.reviewStars);
  }

  @override
  List<Object> get props => [color, size, sizeStatus, reviewStars, numReview];
}
