import '../../../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> addOrder(Order item);
  Future<List<Order>> getOrders();
}
