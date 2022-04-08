import 'package:e_commerce_app/modules/models/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> addProductToCart(CartModel item);
  Future<List<CartModel>> removeCart(CartModel item);
  Future<List<CartModel>> removeCartByOne(CartModel item);
  bool checkContainTitle(String title);
  int getIndexContainList(CartModel item);
  double getTotalPrice();
  Future<List<CartModel>> getCarts();
}
