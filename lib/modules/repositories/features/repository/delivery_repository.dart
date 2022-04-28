import 'package:e_commerce_app/modules/models/delivery.dart';

import '../../x_result.dart';

abstract class DeliveryRepository {
  Future<XResult<List<Delivery>>> getDeliveries();
  Future<Delivery> getDeliveryById(String id);
  Future<List<Delivery>> setDeliveries(List<Delivery> deli);
}
