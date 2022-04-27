import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

import '../x_result.dart';

class CartProvider extends BaseCollectionReference<CartModel> {
  CartProvider()
      : super(FirebaseFirestore.instance
            .collection('carts')
            .withConverter<CartModel>(
                fromFirestore: (snapshot, options) =>
                    CartModel.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (cart, _) => cart.toJson()));

  Future<XResult<CartModel>> setProductToCart(CartModel cartModel) async {
    return await set(cartModel);
  }

  Future<XResult<String>> removeCart(CartModel cartModel) async {
    return await remove(cartModel.id ?? "");
  }

  Future<XResult<List<CartModel>>> getCartByUser(String id) async {
    final XResult<List<CartModel>> res = await queryWhereId('userId', id);

    return res;
  }
}
