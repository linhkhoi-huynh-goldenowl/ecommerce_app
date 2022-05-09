import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/delivery_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/delivery_provider.dart';

import '../../x_result.dart';

class DeliveryRepositoryImpl extends DeliveryRepository {
  final DeliveryProvider _deliveryProvider = DeliveryProvider();
  @override
  Future<Stream<XResult<List<Delivery>>>> getDeliveriesStream() async {
    return _deliveryProvider.snapshotsAll();
  }
}
