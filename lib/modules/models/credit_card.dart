import 'package:e_commerce_app/modules/models/base_model.dart';

class CreditCard extends BaseModel {
  final String nameOnCard;
  final String cardNumber;
  final String expireDate;
  bool isDefault;
  String? userId;

  CreditCard(
      {String? id,
      required this.nameOnCard,
      required this.cardNumber,
      required this.expireDate,
      required this.isDefault,
      this.userId})
      : super(id: id);

  factory CreditCard.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return CreditCard(
      id: id ?? parsedJson['id'],
      nameOnCard: parsedJson['nameOnCard'],
      cardNumber: parsedJson['cardNumber'],
      expireDate: parsedJson['expireDate'],
      isDefault: parsedJson['isDefault'],
      userId: parsedJson['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameOnCard': nameOnCard,
      'cardNumber': cardNumber,
      'expireDate': expireDate,
      'isDefault': isDefault,
      'userId': userId,
    };
  }
}
