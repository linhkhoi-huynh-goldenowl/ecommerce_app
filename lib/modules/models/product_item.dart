class ProductItem {
  final String title;
  final String brandName;
  final String image;
  final double price;
  final DateTime createdDate;
  double? priceSale;
  final bool isPopular;
  final int numberReviews;
  final int reviewStars;
  final String categoryName;

  ProductItem(
      this.brandName,
      this.image,
      this.price,
      this.numberReviews,
      this.reviewStars,
      this.title,
      this.createdDate,
      this.isPopular,
      this.categoryName,
      [this.priceSale]);
}
