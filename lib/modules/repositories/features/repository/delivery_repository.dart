import 'package:e_commerce_shop_app/modules/models/delivery.dart';

abstract class DeliveryRepository {
  Future<List<Delivery>> getDeliveries();
  Future<Delivery> getDeliveryById(String id);
}
