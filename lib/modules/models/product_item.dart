import 'package:e_commerce_app/modules/models/size_cloth.dart';
import 'package:equatable/equatable.dart';

class ProductItem extends Equatable {
  final String title;
  final String brandName;
  final String image;
  final DateTime createdDate;
  final double? salePercent;
  final bool isPopular;
  final int numberReviews;
  final int reviewStars;
  final String categoryName;
  final String color;
  final List<SizeCloth> sizes;
  const ProductItem(
      this.brandName,
      this.image,
      this.numberReviews,
      this.reviewStars,
      this.title,
      this.createdDate,
      this.isPopular,
      this.categoryName,
      this.color,
      this.sizes,
      [this.salePercent]);

  @override
  List<Object?> get props => [
        title,
        brandName,
        image,
        numberReviews,
        reviewStars,
        createdDate,
        isPopular,
        categoryName,
        color,
        sizes,
        salePercent
      ];
}
