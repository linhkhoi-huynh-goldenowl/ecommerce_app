import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/order.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/order_provider.dart';
import '../../x_result.dart';

class OrderRepositoryImpl extends OrderRepository {
  List<Order> _listOrders = [];
  final OrderProvider _orderProvider = OrderProvider();
  @override
  Future<List<Order>> addOrder(Order item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    item.createdDate = Timestamp.now();
    item.id = "$userId-${item.createdDate!.toDate().toIso8601String()}";

    XResult<Order> result = await _orderProvider.addOrder(item);
    _listOrders.add(result.data!);

    return _listOrders;
  }

  @override
  Future<List<Order>> getOrders() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<Order>> result = await _orderProvider.getOrderByUser(userId!);
    _listOrders = result.data ?? [];
    _listOrders.sort(
      (a, b) => b.createdDate!.toDate().compareTo(a.createdDate!.toDate()),
    );
    return _listOrders;
  }
}
