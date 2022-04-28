import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/address_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../x_result.dart';

class AddressRepositoryImpl extends AddressRepository {
  List<Address> _listAddress = [];
  final AddressProvider _addressProvider = AddressProvider();
  @override
  Future<List<Address>> addAddress(Address item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");

    var createdDate = DateTime.now().toIso8601String();
    item.userId = userId;
    item.id = "$userId-$createdDate";

    XResult<Address> result = await _addressProvider.addAddress(item);
    _listAddress.add(result.data!);

    return _listAddress;
  }

  @override
  Future<List<Address>> getAddress() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    XResult<List<Address>> result =
        await _addressProvider.getAddressByUser(userId ?? "");
    _listAddress = result.data ?? [];
    return _listAddress;
  }

  @override
  Future<List<Address>> removeAddress(Address item) async {
    await _addressProvider.removeAddress(item);
    _listAddress.removeWhere(
        (element) => element.id == item.id && element.userId == item.userId);

    return _listAddress;
  }

  @override
  Future<List<Address>> editAddress(Address item) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getString("userId");
    item.userId = userId;
    XResult<Address> result = await _addressProvider.addAddress(item);

    int indexAddress =
        _listAddress.indexWhere((element) => element.id == result.data!.id);
    _listAddress[indexAddress] = item;

    return _listAddress;
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
