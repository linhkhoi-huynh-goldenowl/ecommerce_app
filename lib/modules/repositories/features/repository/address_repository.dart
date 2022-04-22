import 'package:e_commerce_shop_app/modules/models/address.dart';

import '../../x_result.dart';

abstract class AddressRepository {
  Future<List<Address>> addAddress(Address item);
  Future<List<Address>> editAddress(Address item);
  Future<List<Address>> setDefaultAddress(Address item);
  Future<List<Address>> removeAddress(Address item);
  Future<List<Address>> getAddress();
  Future<Stream<XResult<List<Address>>>> getAddressStream();
  Future<List<Address>> setAddress(List<Address> addresses);
}
