import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/base_model.dart';
import 'package:e_commerce_shop_app/modules/models/color_cloth.dart';
import 'package:e_commerce_shop_app/modules/models/tag_model.dart';

class ProductItem extends BaseModel {
  final String title;
  final String brandName;
  final List<String> images;
  final Timestamp createdDate;
  final double? salePercent;
  final bool isPopular;
  int numberReviews;
  int reviewStars;
  List<TagModel>? tags;
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
      this.tags,
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
    List<TagModel> _tags = [];

    if (parsedJson['tags'] != null) {
      var tagsObjJson = parsedJson['tags'] as List;
      _tags = tagsObjJson.map((tagJson) => TagModel.fromJson(tagJson)).toList();
    }

    return ProductItem(
        id: id ?? parsedJson['id'],
        title: parsedJson['title'],
        tags: _tags,
        brandName: parsedJson['brandName'],
        images: parsedJson['images'].cast<String>(),
        description: parsedJson['description'],
        numberReviews: parsedJson['numberReviews'],
        reviewStars: parsedJson['reviewStars'],
        createdDate: parsedJson['createdDate'],
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

    List<Map<String, dynamic>> tagsList = tags!.map((i) => i.toJson()).toList();
    return {
      'id': id,
      'title': title,
      'brandName': brandName,
      'createdDate': createdDate,
      'isPopular': isPopular,
      'images': images,
      'numberReviews': numberReviews,
      'reviewStars': reviewStars,
      'categoryName': categoryName,
      'colors': colorsList,
      'salePercent': salePercent,
      'tags': tagsList,
      'description': description
    };
  }
}
