import 'package:e_commerce_shop_app/modules/models/base_model.dart';

class Address extends BaseModel {
  final String fullName;
  final String address;
  final String city;
  final String region;
  final String zipCode;
  final String country;
  bool isDefault;
  String? userId;

  Address(
      {String? id,
      required this.fullName,
      required this.address,
      required this.city,
      required this.region,
      required this.zipCode,
      required this.country,
      required this.isDefault,
      this.userId})
      : super(id: id);

  factory Address.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return Address(
      id: id ?? parsedJson['id'],
      fullName: parsedJson['fullName'],
      address: parsedJson['address'],
      city: parsedJson['city'],
      userId: parsedJson['userId'],
      region: parsedJson['region'],
      zipCode: parsedJson['zipCode'],
      country: parsedJson['country'],
      isDefault: parsedJson['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'userId': userId,
      'address': address,
      'city': city,
      'region': region,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault
    };
  }
}
