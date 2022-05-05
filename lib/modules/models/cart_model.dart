import 'package:e_commerce_shop_app/modules/models/base_model.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';

class CartModel extends BaseModel {
  final String title;
  final ProductItem productItem;
  final String size;
  final String color;
  int quantity;
  String? userId;
  CartModel(
      {String? id,
      required this.title,
      required this.productItem,
      required this.size,
      required this.color,
      required this.quantity,
      this.userId})
      : super(id: id);

  factory CartModel.fromJson(Map<String, dynamic> parsedJson, {String? id}) {
    return CartModel(
        id: id ?? parsedJson['id'],
        title: parsedJson['title'],
        productItem: ProductItem.fromJson(parsedJson['productItem']),
        size: parsedJson['size'],
        userId: parsedJson['userId'],
        color: parsedJson['color'],
        quantity: parsedJson['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productItem': productItem.toJson(),
      'size': size,
      'userId': userId,
      'color': color,
      'quantity': quantity,
      'title': title
    };
  }
}
