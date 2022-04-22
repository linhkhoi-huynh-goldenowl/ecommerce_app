import 'package:e_commerce_shop_app/modules/models/base_model.dart';
import 'package:e_commerce_shop_app/modules/models/color_cloth.dart';

class ProductItem extends BaseModel {
  final String title;
  final String brandName;
  final List<String> images;
  final DateTime createdDate;
  final double? salePercent;
  final bool isPopular;
  int numberReviews;
  int reviewStars;
  final String categoryName;
  final String description;
  final List<ColorCloth> colors;
  ProductItem(
      {String? id,
      required this.brandName,
      required this.images,
      required this.numberReviews,
      required this.reviewStars,
      required this.title,
      required this.createdDate,
      required this.isPopular,
      required this.categoryName,
      required this.colors,
      required this.description,
      this.salePercent})
      : super(id: id);

  factory ProductItem.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    var colorsObjJson = parsedJson['colors'] as List;
    List<ColorCloth> _colors = colorsObjJson
        .map((colorJson) => ColorCloth.fromJson(colorJson))
        .toList();
    return ProductItem(
        id: id ?? parsedJson['id'],
        title: parsedJson['title'],
        brandName: parsedJson['brandName'],
        images: parsedJson['images'].cast<String>(),
        description: parsedJson['description'],
        numberReviews: parsedJson['numberReviews'],
        reviewStars: parsedJson['reviewStars'],
        createdDate: DateTime.parse(parsedJson['createdDate']),
        isPopular: parsedJson['isPopular'],
        categoryName: parsedJson['categoryName'],
        colors: _colors,
        // ignore: prefer_null_aware_operators
        salePercent: parsedJson['salePercent'] != null
            ? parsedJson['salePercent'].toDouble()
            : null);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> colorsList =
        colors.map((i) => i.toJson()).toList();
    return {
      'id': id,
      'title': title,
      'brandName': brandName,
      'createdDate': createdDate.toIso8601String(),
      'isPopular': isPopular,
      'images': images,
      'numberReviews': numberReviews,
      'reviewStars': reviewStars,
      'categoryName': categoryName,
      'colors': colorsList,
      'salePercent': salePercent,
      'description': description
    };
  }
}
