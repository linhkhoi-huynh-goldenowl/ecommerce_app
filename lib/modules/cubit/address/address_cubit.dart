import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/x_result.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(const AddressState()) {
    fetchAddress();
  }
  StreamSubscription? addressSubscription;
  @override
  Future<void> close() {
    addressSubscription?.cancel();
    return super.close();
  }

  void fetchAddress() async {
    try {
      emit(state.copyWith(status: AddressStatus.loading));
      final Stream<XResult<List<Address>>> addressStream =
          await Domain().address.getAddressStream();

      addressSubscription = addressStream.listen((event) async {
        emit(state.copyWith(status: AddressStatus.loading));
        var listAddress = await Domain().address.setAddress(event.data ?? []);

        emit(state.copyWith(
            status: AddressStatus.success, addresses: listAddress));
      });
      // var addresses = await Domain().address.getAddress();
      // emit(state.copyWith(status: AddressStatus.success, addresses: addresses));
    } catch (_) {
      emit(state.copyWith(status: AddressStatus.failure));
    }
  }

  void addAddress(Address address) async {
    try {
      emit(state.copyWith(
          status: AddressStatus.loading,
          typeStatus: AddressTypeStatus.submitting));
      var addresses = await Domain().address.addAddress(address);

      var localUser = await Domain().profile.getProfile();
      localUser.shippingAddress = localUser.shippingAddress + 1;
      await Domain().profile.saveProfile(localUser);
      emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          typeStatus: AddressTypeStatus.submitted));
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure,
          typeStatus: AddressTypeStatus.initial));
    }
  }

  void editAddress(Address address) async {
    try {
      emit(state.copyWith(
          status: AddressStatus.loading,
          typeStatus: AddressTypeStatus.submitting));
      var addresses = await Domain().address.editAddress(address);
      emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          typeStatus: AddressTypeStatus.submitted));
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure,
          typeStatus: AddressTypeStatus.initial));
    }
  }

  void setDefaultAddress(Address address) async {
    try {
      emit(state.copyWith(
          status: AddressStatus.loading,
          typeStatus: AddressTypeStatus.submitting));
      var addresses = await Domain().address.setDefaultAddress(address);
      emit(state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          typeStatus: AddressTypeStatus.submitted));
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure,
          typeStatus: AddressTypeStatus.initial));
    }
  }

  void removeAddress(Address address) async {
    try {
      emit(state.copyWith(status: AddressStatus.loading));
      var addresses = await Domain().address.removeAddress(address);
      var localUser = await Domain().profile.getProfile();
      localUser.shippingAddress = localUser.shippingAddress - 1;
      await Domain().profile.saveProfile(localUser);
      emit(state.copyWith(status: AddressStatus.success, addresses: addresses));
    } catch (_) {
      emit(state.copyWith(status: AddressStatus.failure));
    }
  }

  void loadInfoAddressForm(Address address) async {
    emit(state.copyWith(
      typeStatus: AddressTypeStatus.initial,
      fullName: address.fullName,
      address: address.address,
      city: address.city,
      region: address.region,
      zipCode: address.zipCode,
      country: address.country,
    ));
  }

  void resetAddressForm() async {
    emit(state.copyWith(
        typeStatus: AddressTypeStatus.initial,
        fullName: "",
        address: "",
        city: "",
        region: "",
        zipCode: "",
        country: ""));
  }

  void fullNameChanged(String fullName) {
    emit(state.copyWith(
        fullName: fullName, typeStatus: AddressTypeStatus.typing));
    if (state.isFullNameValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }

  void addressChanged(String address) {
    emit(
        state.copyWith(address: address, typeStatus: AddressTypeStatus.typing));
    if (state.isAddressValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }

  void cityChanged(String city) {
    emit(state.copyWith(city: city, typeStatus: AddressTypeStatus.typing));
    if (state.isCityValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }

  void regionChanged(String region) {
    emit(state.copyWith(region: region, typeStatus: AddressTypeStatus.typing));
    if (state.isRegionValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }

  void zipCodeChanged(String zipCode) {
    emit(
        state.copyWith(zipCode: zipCode, typeStatus: AddressTypeStatus.typing));
    if (state.isZipCodeValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }

  void setCountry(String country) {
    emit(
        state.copyWith(country: country, typeStatus: AddressTypeStatus.typing));
    if (state.isCountryValid) {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typed));
    } else {
      emit(state.copyWith(typeStatus: AddressTypeStatus.typing));
    }
  }
}
