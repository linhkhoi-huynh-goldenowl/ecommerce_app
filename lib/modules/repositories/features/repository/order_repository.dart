import '../../../models/order.dart';
import '../../x_result.dart';

abstract class OrderRepository {
  Future<XResult<Order>> addOrder(Order item);
  Future<Stream<XResult<List<Order>>>> getOrderStream();
  Future<List<Order>> setOrder(List<Order> orders);
  Future<List<Order>> getOrdersByDelivered();
  Future<List<Order>> getOrdersByProcessing();
  Future<List<Order>> getOrdersByCancelled();
}
