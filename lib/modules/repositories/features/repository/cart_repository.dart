import 'package:e_commerce_shop_app/modules/models/cart_model.dart';

import '../../x_result.dart';

abstract class CartRepository {
  Future<XResult<CartModel>> addProductToCart(CartModel item);
  Future<Stream<XResult<List<CartModel>>>> getCartStream();
  Future<XResult<String>> reorderToCart(List<CartModel> items);
  Future<XResult<String>> removeCart(CartModel item);

  Future<XResult<CartModel>> removeCartByOne(CartModel item);

  Future<XResult<String>> clearCarts();
}
