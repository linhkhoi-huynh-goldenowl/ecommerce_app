import 'package:e_commerce_shop_app/modules/models/cart_model.dart';

import '../../../models/favorite_product.dart';
import '../../x_result.dart';

abstract class CartRepository {
  Future<XResult<CartModel>> addProductToCart(CartModel item);
  Future<Stream<XResult<List<CartModel>>>> getCartStream();
  bool checkContainInFavorite(FavoriteProduct item);
  Future<XResult<String>> reorderToCart(List<CartModel> items);
  Future<XResult<String>> removeCart(CartModel item);

  Future<XResult<CartModel>> removeCartByOne(CartModel item);
  Future<List<CartModel>> getCartByName(String searchName);
  bool checkContainTitle(String title);
  int getIndexContainList(CartModel item);
  double getTotalPrice([int? salePercent]);
  Future<List<CartModel>> setCarts(List<CartModel> carts);
  Future<XResult<String>> clearCarts();
}
