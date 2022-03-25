import 'package:equatable/equatable.dart';

class ProductItem extends Equatable {
  final String title;
  final String brandName;
  final String image;
  final double price;
  final DateTime createdDate;
  final double? priceSale;
  final bool isPopular;
  final int numberReviews;
  final int reviewStars;
  final String categoryName;
  final String color;
  final Map<String, int> size;
  const ProductItem(
      this.brandName,
      this.image,
      this.price,
      this.numberReviews,
      this.reviewStars,
      this.title,
      this.createdDate,
      this.isPopular,
      this.categoryName,
      this.color,
      this.size,
      [this.priceSale]);

  @override
  List<Object?> get props => [
        title,
        brandName,
        price,
        image,
        numberReviews,
        reviewStars,
        createdDate,
        isPopular,
        categoryName,
        color,
        size,
        priceSale
      ];
}
