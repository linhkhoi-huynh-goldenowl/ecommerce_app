import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class PromoModel extends BaseModel {
  final String name;
  final int salePercent;
  final Timestamp endDate;
  final String backgroundImage;
  PromoModel({
    String? id,
    required this.name,
    required this.salePercent,
    required this.endDate,
    required this.backgroundImage,
  }) : super(id: id);

  factory PromoModel.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return PromoModel(
      id: id ?? parsedJson['id'],
      name: parsedJson['name'],
      salePercent: parsedJson['salePercent'].toInt(),
      endDate: parsedJson['endDate'],
      backgroundImage: parsedJson['backgroundImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salePercent': salePercent,
      'endDate': endDate,
      'backgroundImage': backgroundImage,
    };
  }
}
