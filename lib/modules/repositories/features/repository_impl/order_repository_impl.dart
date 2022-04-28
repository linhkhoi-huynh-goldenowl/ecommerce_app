import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/models/order.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/order_provider.dart';
import '../../x_result.dart';

class OrderRepositoryImpl extends OrderRepository {
  List<Order> _listOrders = [];
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
  Future<List<Order>> getOrdersByCancelled() async {
    return _listOrders
        .where((element) => element.status == "Cancelled")
        .toList();
  }

  @override
  Future<List<Order>> getOrdersByDelivered() async {
    return _listOrders
        .where((element) => element.status == "Delivered")
        .toList();
  }

  @override
  Future<List<Order>> getOrdersByProcessing() async {
    return _listOrders
        .where((element) => element.status == "Processing")
        .toList();
  }

  @override
  Future<Stream<XResult<List<Order>>>> getOrderStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _orderProvider.snapshotsAllQuery("userId", userId!);
  }

  @override
  Future<List<Order>> setOrder(List<Order> orders) async {
    _listOrders = orders;
    return _listOrders;
  }
}
