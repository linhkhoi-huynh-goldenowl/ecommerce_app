import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/base_collection.dart';

import '../../models/order.dart';
import '../x_result.dart';

class OrderProvider extends BaseCollectionReference<Order> {
  OrderProvider()
      : super(FirebaseFirestore.instance
            .collection('orders')
            .withConverter<Order>(
                fromFirestore: (snapshot, options) =>
                    Order.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (order, _) => order.toJson()));

  Future<XResult<Order>> addOrder(Order order) async {
    return await set(order);
  }

  Future<XResult<List<Order>>> getOrderByUser(String id) async {
    final XResult<List<Order>> res = await queryWhereId('userId', id);

    return res;
  }
}
