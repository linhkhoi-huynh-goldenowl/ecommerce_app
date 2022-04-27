import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class Delivery extends BaseModel {
  final String name;
  final String imgUrl;
  final int days;
  final double shipPrice;
  Delivery({
    String? id,
    required this.name,
    required this.imgUrl,
    required this.days,
    required this.shipPrice,
  }) : super(id: id);

  factory Delivery.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return Delivery(
      id: id ?? parsedJson['id'],
      name: parsedJson['name'],
      days: parsedJson['days'],
      imgUrl: parsedJson['imgUrl'],
      shipPrice: parsedJson['shipPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'imgUrl': imgUrl,
      'shipPrice': shipPrice
    };
  }
}
