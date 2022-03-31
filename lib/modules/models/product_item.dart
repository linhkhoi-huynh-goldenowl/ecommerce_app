import 'package:e_commerce_app/modules/models/base_model.dart';
import 'package:e_commerce_app/modules/models/size_cloth.dart';

class ProductItem extends BaseModel {
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
  ProductItem(
      {String? id,
      required this.brandName,
      required this.image,
      required this.numberReviews,
      required this.reviewStars,
      required this.title,
      required this.createdDate,
      required this.isPopular,
      required this.categoryName,
      required this.color,
      required this.sizes,
      this.salePercent})
      : super(id: id);

  factory ProductItem.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    var sizeObjJson = parsedJson['sizes'] as List;
    List<SizeCloth> _sizes =
        sizeObjJson.map((sizeJson) => SizeCloth.fromJson(sizeJson)).toList();
    return ProductItem(
        id: id ?? parsedJson['id'],
        title: parsedJson['title'],
        brandName: parsedJson['brandName'],
        image: parsedJson['image'],
        numberReviews: parsedJson['numberReviews'],
        reviewStars: parsedJson['reviewStars'],
        createdDate: DateTime.parse(parsedJson['createdDate']),
        isPopular: parsedJson['isPopular'],
        categoryName: parsedJson['categoryName'],
        color: parsedJson['color'],
        sizes: _sizes,
        salePercent: parsedJson['salePercent']);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> sizesList =
        sizes.map((i) => i.toJson()).toList();
    return {
      'id': id,
      'title': title,
      'brandName': brandName,
      'createdDate': createdDate.toIso8601String(),
      'isPopular': isPopular,
      'image': image,
      'numberReviews': numberReviews,
      'reviewStars': reviewStars,
      'categoryName': categoryName,
      'color': color,
      'sizes': sizesList,
      'salePercent': salePercent
    };
  }
}
