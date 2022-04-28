import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/repositories/provider/base_collection.dart';

import '../../models/delivery.dart';
import '../x_result.dart';

class DeliveryProvider extends BaseCollectionReference<Delivery> {
  DeliveryProvider()
      : super(FirebaseFirestore.instance
            .collection('deliveries')
            .withConverter<Delivery>(
                fromFirestore: (snapshot, options) =>
                    Delivery.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (delivery, _) => delivery.toJson()));

  Future<XResult<List<Delivery>>> getAllDelivery() async {
    final XResult<List<Delivery>> res = await query();
    return res;
  }
}
