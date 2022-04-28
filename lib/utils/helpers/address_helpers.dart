import 'package:e_commerce_app/modules/models/address.dart';

class AddressHelper {
  static Address? getDefaultAddress(List<Address> addresses) {
    if (addresses.isEmpty) {
      return null;
    } else {
      var defaultAddress =
          addresses.where((element) => element.isDefault == true).toList();
      if (defaultAddress.isNotEmpty) {
        return defaultAddress[0];
      } else {
        return null;
      }
    }
  }
}
