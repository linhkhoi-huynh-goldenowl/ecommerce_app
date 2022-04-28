import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/models/address.dart';
import 'package:e_commerce_app/modules/repositories/provider/base_collection.dart';

import '../x_result.dart';

class AddressProvider extends BaseCollectionReference<Address> {
  AddressProvider()
      : super(FirebaseFirestore.instance
            .collection('addresses')
            .withConverter<Address>(
                fromFirestore: (snapshot, options) =>
                    Address.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (address, _) => address.toJson()));

  Future<XResult<Address>> addAddress(Address address) async {
    return await set(address);
  }

  Future<XResult<String>> removeAddress(Address address) async {
    return await remove(address.id ?? "");
  }

  Future<XResult<List<Address>>> getAddressByUser(String id) async {
    final XResult<List<Address>> res = await queryWhereId('userId', id);

    return res;
  }
}
