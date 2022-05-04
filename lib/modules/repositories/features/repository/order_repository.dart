import '../../../models/order.dart';
import '../../x_result.dart';

abstract class OrderRepository {
  Future<XResult<Order>> addOrder(Order item);
  Future<Stream<XResult<List<Order>>>> getOrderStream();

  Future<List<Order>> getOrdersByDelivered(List<Order> orders);
  Future<List<Order>> getOrdersByProcessing(List<Order> orders);
  Future<List<Order>> getOrdersByCancelled(List<Order> orders);
}
