import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class EUser extends BaseModel {
  final String email;
  final String name;
  final String? imageUrl;
  final DateTime? dateOfBirth;
  int shippingAddress;
  String? creditDefault;
  int orderCount;
  int reviewCount;
  final bool notificationSale;
  final bool notificationNewArrivals;
  final bool notificationDelivery;
  EUser({
    String? id,
    required this.email,
    required this.name,
    this.imageUrl,
    this.dateOfBirth,
    this.creditDefault,
    required this.reviewCount,
    required this.orderCount,
    required this.shippingAddress,
    required this.notificationSale,
    required this.notificationNewArrivals,
    required this.notificationDelivery,
  }) : super(id: id);

  factory EUser.fromJson(Map<String, dynamic> parsedJson, {String? id}) =>
      EUser(
        id: id ?? parsedJson['id'],
        email: parsedJson['email'],
        name: parsedJson['name'],
        imageUrl: parsedJson['imageUrl'],
        creditDefault: parsedJson['creditDefault'],
        dateOfBirth: parsedJson['dateOfBirth'] != null
            ? DateTime.parse(parsedJson['dateOfBirth'])
            : null,
        reviewCount: parsedJson['reviewCount'],
        orderCount: parsedJson['orderCount'],
        shippingAddress: parsedJson['shippingAddress'],
        notificationDelivery: parsedJson['notificationDelivery'],
        notificationNewArrivals: parsedJson['notificationNewArrivals'],
        notificationSale: parsedJson['notificationSale'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'imageUrl': imageUrl,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'shippingAddress': shippingAddress,
        'notificationSale': notificationSale,
        'notificationNewArrivals': notificationNewArrivals,
        'notificationDelivery': notificationDelivery,
        'creditDefault': creditDefault,
        'orderCount': orderCount,
        'reviewCount': reviewCount
      };
}
