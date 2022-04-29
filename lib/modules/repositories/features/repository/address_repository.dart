import 'package:e_commerce_shop_app/modules/models/address.dart';

import '../../x_result.dart';

abstract class AddressRepository {
  Future<XResult<Address>> addAddress(Address item);
  Future<XResult<Address>> editAddress(Address item);
  Future<XResult<String>> removeAddress(Address item);
  Future<Stream<XResult<List<Address>>>> getAddressStream();
  Future<List<Address>> setAddress(List<Address> addresses);
  Future<XResult<Address>> setDefaultAddress(Address itemNew);
  Future<XResult<Address>> setUnDefaultAddress(Address itemOld);
}
