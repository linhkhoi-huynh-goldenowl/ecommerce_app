import '../../../models/order.dart';
import '../../x_result.dart';

abstract class OrderRepository {
  Future<XResult<Order>> addOrder(Order item);
  Future<Stream<XResult<List<Order>>>> getOrderStream(String statusOrder);
}
