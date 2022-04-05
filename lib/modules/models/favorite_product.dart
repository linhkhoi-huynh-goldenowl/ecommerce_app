import 'package:e_commerce_app/modules/models/base_model.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';

class FavoriteProduct extends BaseModel {
  final ProductItem productItem;
  final String size;
  String? userId;
  FavoriteProduct(
      {String? id, required this.productItem, required this.size, this.userId})
      : super(id: id);

  factory FavoriteProduct.fromJson(Map<String, dynamic> parsedJson,
      {String? id}) {
    return FavoriteProduct(
        id: id ?? parsedJson['id'],
        productItem: ProductItem.fromJson(parsedJson['productItem']),
        size: parsedJson['size'],
        userId: parsedJson['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productItem': productItem.toJson(),
      'size': size,
      'userId': userId
    };
  }
}
