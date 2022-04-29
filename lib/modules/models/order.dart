import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/models/base_model.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';

class Order extends BaseModel {
  final Delivery delivery;
  final CreditCard card;
  final Address address;
  Timestamp? createdDate;
  final PromoModel? promoModel;
  final List<CartModel> listItems;
  final String status;
  final double totalAmount;
  String? userId;
  Order({
    String? id,
    required this.delivery,
    required this.card,
    required this.address,
    this.createdDate,
    this.promoModel,
    required this.listItems,
    required this.status,
    required this.totalAmount,
    this.userId,
  }) : super(id: id);

  factory Order.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    var listItemsObjJson = parsedJson['listItems'] as List;
    List<CartModel> _items = listItemsObjJson
        .map((itemJson) => CartModel.fromJson(itemJson))
        .toList();
    return Order(
      id: id ?? parsedJson['id'],
      delivery: Delivery.fromJson(parsedJson['delivery']),
      card: CreditCard.fromJson(parsedJson['card']),
      address: Address.fromJson(parsedJson['address']),
      createdDate: parsedJson['createdDate'],
      promoModel: parsedJson['promoModel'] != null
          ? PromoModel.fromJson(parsedJson['promoModel'])
          : null,
      listItems: _items,
      status: parsedJson['status'],
      totalAmount: parsedJson['totalAmount'].toDouble(),
      userId: parsedJson['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemList =
        listItems.map((i) => i.toJson()).toList();
    return {
      'id': id,
      'listItems': itemList,
      'delivery': delivery.toJson(),
      'card': card.toJson(),
      'address': address.toJson(),
      'createdDate': createdDate,
      'promoModel': promoModel != null ? promoModel!.toJson() : promoModel,
      'status': status,
      'totalAmount': totalAmount,
      'userId': userId,
    };
  }
}
