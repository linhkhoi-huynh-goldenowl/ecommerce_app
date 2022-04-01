import 'package:e_commerce_app/modules/models/base_model.dart';

class EUser extends BaseModel {
  final String email;
  final String name;
  final DateTime? dateOfBirth;
  final List<String> shippingAddress;
  final bool notificationSale;
  final bool notificationNewArrivals;
  final bool notificationDelivery;
  EUser({
    String? id,
    required this.email,
    required this.name,
    this.dateOfBirth,
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
        dateOfBirth: parsedJson['dateOfBirth'] != null
            ? DateTime.parse(parsedJson['dateOfBirth'])
            : null,
        shippingAddress: parsedJson['shippingAddress'].cast<String>(),
        notificationDelivery: parsedJson['notificationDelivery'],
        notificationNewArrivals: parsedJson['notificationNewArrivals'],
        notificationSale: parsedJson['notificationSale'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'shippingAddress': shippingAddress,
        'notificationSale': notificationSale,
        'notificationNewArrivals': notificationNewArrivals,
        'notificationDelivery': notificationDelivery,
      };
}
