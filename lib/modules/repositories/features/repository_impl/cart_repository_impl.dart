import 'package:e_commerce_app/modules/models/cart_model.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/cart_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/cart_provider.dart';
import 'package:e_commerce_app/utils/helpers/product_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class CartRepositoryImpl extends CartRepository {
  List<CartModel> _listCarts = [];
  final CartProvider _cartProvider = CartProvider();
  @override
  Future<List<CartModel>> addProductToCart(CartModel item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.id = "$userId-${item.productItem.id}- ${item.size}";
    int indexCart = getIndexContainList(item);
    if (indexCart < 0) {
      XResult<CartModel> result = await _cartProvider.setProductToCart(item);
      _listCarts.add(result.data!);
    } else {
      final cartItem = _listCarts[indexCart];
      cartItem.quantity += 1;
      XResult<CartModel> result =
          await _cartProvider.setProductToCart(cartItem);
      _listCarts[indexCart] = result.data!;
    }

    return _listCarts;
  }

  @override
  bool checkContainTitle(String title) {
    return _listCarts
        .where((element) => element.productItem.title == title)
        .toList()
        .isNotEmpty;
  }

  @override
  int getIndexContainList(CartModel item) {
    return _listCarts.indexWhere((element) =>
        element.productItem.title == item.productItem.title &&
        element.size == item.size &&
        element.color == item.color);
  }

  @override
  Future<List<CartModel>> getCarts() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<CartModel>> result =
        await _cartProvider.getCartByUser(userId ?? "");
    _listCarts = result.data ?? [];
    return _listCarts;
  }

  @override
  Future<List<CartModel>> removeCart(CartModel item) async {
    await _cartProvider.removeCart(item);
    _listCarts.removeWhere((element) =>
        element.size == item.size &&
        element.productItem.title == item.productItem.title &&
        element.color == item.color);

    return _listCarts;
  }

  @override
  Future<List<CartModel>> removeCartByOne(CartModel item) async {
    if (item.quantity < 2) {
      return await removeCart(item);
    } else {
      item.quantity -= 1;
      XResult<CartModel> result = await _cartProvider.setProductToCart(item);
      _listCarts[_listCarts.indexOf(item)] = result.data!;
    }

    return _listCarts;
  }

  @override
  double getTotalPrice([int? salePercent]) {
    double total = 0;

    for (var item in _listCarts) {
      double price = ProductHelper.getPriceWithSaleItem(
          item.productItem, item.color, item.size);

      total += (item.quantity * price);
    }
    if (salePercent != null && salePercent > 0) {
      total = total - (total * salePercent / 100);
    }
    return total;
  }
}
