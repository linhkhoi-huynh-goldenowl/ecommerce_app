import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/favorite_product.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/cart_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/cart_provider.dart';
import 'package:e_commerce_shop_app/utils/helpers/product_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class CartRepositoryImpl extends CartRepository {
  List<CartModel> _listCarts = [];
  final CartProvider _cartProvider = CartProvider();
  @override
  Future<XResult<CartModel>> addProductToCart(CartModel item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.id = "$userId-${item.productItem.id}- ${item.size}";
    int indexCart = getIndexContainList(item);
    if (indexCart < 0) {
      return await _cartProvider.setProductToCart(item);
    } else {
      final cartItem = _listCarts[indexCart];
      cartItem.quantity += 1;
      return await _cartProvider.setProductToCart(cartItem);
    }
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
        element.productItem.id == item.productItem.id &&
        element.size == item.size &&
        element.color == item.color);
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

  @override
  Future<XResult<String>> clearCarts() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return await _cartProvider.removeByUserId(userId!);
  }

  @override
  Future<List<CartModel>> setCarts(List<CartModel> carts) async {
    _listCarts = carts;
    return _listCarts;
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

  @override
  bool checkContainInFavorite(FavoriteProduct item) {
    return _listCarts
        .where((element) =>
            element.productItem.id == item.productItem.id &&
            element.size == item.size)
        .toList()
        .isNotEmpty;
  }

  @override
  Future<List<CartModel>> getCartByName(String searchName) async {
    return _listCarts
        .where((element) => element.productItem.title
            .toLowerCase()
            .contains(searchName.toLowerCase()))
        .toList();
  }
}
