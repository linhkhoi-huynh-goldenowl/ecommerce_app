import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/order.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/order_provider.dart';
import '../../x_result.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderProvider _orderProvider = OrderProvider();
  @override
  Future<XResult<Order>> addOrder(Order item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.createdDate = Timestamp.now();
    item.id = "$userId-${item.createdDate!.toDate().toIso8601String()}";

    return await _orderProvider.addOrder(item);
  }

  @override
  Future<Stream<XResult<List<Order>>>> getOrderStream(
      String statusOrder) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _orderProvider.snapshotsAllQueryTwoCondition(
        "userId", userId!, "status", statusOrder);
  }
}
