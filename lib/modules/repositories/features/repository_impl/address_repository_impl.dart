import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/address_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class AddressRepositoryImpl extends AddressRepository {
  List<Address> _listAddress = [];
  final AddressProvider _addressProvider = AddressProvider();
  @override
  Future<XResult<Address>> addAddress(Address item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");

    var createdDate = DateTime.now().toIso8601String();
    item.userId = userId;
    item.id = "$userId-$createdDate";

    return await _addressProvider.addAddress(item);
  }

  @override
  Future<XResult<String>> removeAddress(Address item) async {
    return await _addressProvider.removeAddress(item);
  }

  @override
  Future<XResult<Address>> editAddress(Address item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;

    return await _addressProvider.addAddress(item);
  }

  @override
  Future<XResult<Address>> setDefaultAddress(Address itemNew) async {
    itemNew.isDefault = true;
    return await _addressProvider.addAddress(itemNew);
  }

  @override
  Future<XResult<Address>> setUnDefaultAddress(Address itemOld) async {
    itemOld.isDefault = false;
    return await _addressProvider.addAddress(itemOld);
  }

  @override
  Future<Stream<XResult<List<Address>>>> getAddressStream() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    return _addressProvider.snapshotsAllQuery("userId", userId!);
  }

  @override
  Future<List<Address>> setAddress(List<Address> addresses) async {
    _listAddress = addresses;
    return _listAddress;
  }
}
