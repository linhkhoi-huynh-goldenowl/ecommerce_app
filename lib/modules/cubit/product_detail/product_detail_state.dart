part of 'product_detail_cubit.dart';

enum SizeStatus { initial, selected, unselected }

class ProductDetailState extends Equatable {
  const ProductDetailState(
      {this.size = "",
      this.color = "",
      this.sizeStatus = SizeStatus.initial,
      this.reviewStars = 0,
      this.numReview = 0,
      this.relatedList = const [],
      this.containFavorite = false});
  final String size;
  final String color;
  final int reviewStars;
  final int numReview;
  final SizeStatus sizeStatus;
  final List<Map<ProductItem, bool>> relatedList;
  final bool containFavorite;
  ProductDetailState copyWith(
      {String? size,
      String? color,
      SizeStatus? sizeStatus,
      int? reviewStars,
      int? numReview,
      List<Map<ProductItem, bool>>? relatedList,
      bool? containFavorite}) {
    return ProductDetailState(
        size: size ?? this.size,
        color: color ?? this.color,
        sizeStatus: sizeStatus ?? this.sizeStatus,
        numReview: numReview ?? this.numReview,
        reviewStars: reviewStars ?? this.reviewStars,
        relatedList: relatedList ?? this.relatedList,
        containFavorite: containFavorite ?? this.containFavorite);
  }

  @override
  List<Object> get props => [
        color,
        size,
        sizeStatus,
        reviewStars,
        numReview,
        relatedList,
        containFavorite
      ];
}
