import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/delivery_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/delivery_provider.dart';

import '../../x_result.dart';

class DeliveryRepositoryImpl extends DeliveryRepository {
  List<Delivery> _listDeliveries = [];
  final DeliveryProvider _deliveryProvider = DeliveryProvider();
  @override
  Future<List<Delivery>> getDeliveries() async {
    XResult<List<Delivery>> result = await _deliveryProvider.getAllDelivery();
    _listDeliveries = result.data ?? [];
    return _listDeliveries;
  }

  @override
  Future<Delivery> getDeliveryById(String id) async {
    final deliveryResult =
        _listDeliveries.firstWhere((element) => element.id == id);
    return deliveryResult;
  }
}
