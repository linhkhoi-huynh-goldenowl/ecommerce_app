import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/cart_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class CartRepositoryImpl extends CartRepository {
  final CartProvider _cartProvider = CartProvider();
  @override
  Future<XResult<CartModel>> addProductToCart(CartModel item) async {
    return await _cartProvider.setProductToCart(item);
  }

  @override
  Future<XResult<String>> removeCart(CartModel item) async {
    return await _cartProvider.removeCart(item);
  }

  @override
  Future<XResult<CartModel>> removeCartByOne(CartModel item) async {
    item.quantity -= 1;
    return await _cartProvider.setProductToCart(item);
  }

  @override
  Future<XResult<String>> clearCarts() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return await _cartProvider.removeByUserId(userId!);
  }

  @override
  Future<Stream<XResult<List<CartModel>>>> getCartStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _cartProvider.snapshotsAllQuery("userId", userId!);
  }

  @override
  Future<XResult<String>> reorderToCart(List<CartModel> items) async {
    for (var item in items) {
      XResult<CartModel> res = await _cartProvider.setProductToCart(item);
      if (res.isError) {
        return XResult.error(res.error);
      }
    }
    return XResult.success("Add complete");
  }
}
