import 'package:e_commerce_shop_app/modules/models/delivery.dart';

import '../../x_result.dart';

abstract class DeliveryRepository {
  Future<Stream<XResult<List<Delivery>>>> getDeliveriesStream();
}
