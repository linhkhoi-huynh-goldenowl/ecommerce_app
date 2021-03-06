import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../models/e_user.dart';
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
        if (event.isError) {
          emit(state.copyWith(
              status: AddressStatus.failure,
              addresses: [],
              errMessage: event.error));
        } else {
          emit(state.copyWith(
              status: AddressStatus.success,
              addresses: event.data,
              errMessage: ""));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure, errMessage: "Something not right"));
    }
  }

  void addAddress(Address address) async {
    try {
      emit(state.copyWith(
          status: AddressStatus.loading,
          typeStatus: AddressTypeStatus.submitting));
      XResult<Address> addressRes = await Domain().address.addAddress(address);
      if (addressRes.isSuccess) {
        var localUser = await Domain().profile.getProfile();
        localUser.shippingAddress = localUser.shippingAddress + 1;
        XResult<EUser> resUser = await Domain().profile.saveProfile(localUser);
        if (resUser.isSuccess) {
          emit(state.copyWith(
              status: AddressStatus.success,
              typeStatus: AddressTypeStatus.submitted,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: AddressStatus.failure,
              typeStatus: AddressTypeStatus.initial,
              errMessage: resUser.error));
        }
      } else {
        emit(state.copyWith(
            status: AddressStatus.failure,
            typeStatus: AddressTypeStatus.initial,
            errMessage: addressRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure,
          typeStatus: AddressTypeStatus.initial,
          errMessage: "Something not right"));
    }
  }

  void editAddress(Address address) async {
    try {
      emit(state.copyWith(
          status: AddressStatus.loading,
          typeStatus: AddressTypeStatus.submitting));
      XResult<Address> addressRes = await Domain().address.editAddress(address);
      if (addressRes.isSuccess) {
        emit(state.copyWith(
            status: AddressStatus.success,
            typeStatus: AddressTypeStatus.submitted,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: AddressStatus.failure,
            typeStatus: AddressTypeStatus.initial,
            errMessage: addressRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: AddressStatus.failure,
          typeStatus: AddressTypeStatus.initial,
          errMessage: "Something not right"));
    }
  }

  void setDefaultAddress(Address address) async {
    try {
      emit(state.copyWith(defaultStatus: AddressDefaultStatus.loading));
      int indexOldDefault =
          state.addresses.indexWhere((element) => element.isDefault == true);
      if (indexOldDefault > -1) {
        XResult<Address> resOld = await Domain()
            .address
            .setUnDefaultAddress(state.addresses[indexOldDefault]);
        if (resOld.isSuccess) {
          XResult<Address> resNew =
              await Domain().address.setDefaultAddress(address);
          if (resNew.isSuccess) {
            emit(state.copyWith(
                defaultStatus: AddressDefaultStatus.success, errMessage: ""));
          } else {
            emit(state.copyWith(
                defaultStatus: AddressDefaultStatus.failure,
                errMessage: resNew.error));
          }
        } else {
          emit(state.copyWith(
              defaultStatus: AddressDefaultStatus.failure,
              errMessage: resOld.error));
        }
      } else {
        XResult<Address> resNew =
            await Domain().address.setDefaultAddress(address);
        if (resNew.isSuccess) {
          emit(state.copyWith(
              defaultStatus: AddressDefaultStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              defaultStatus: AddressDefaultStatus.failure,
              errMessage: resNew.error));
        }
      }
    } catch (_) {
      emit(state.copyWith(
          defaultStatus: AddressDefaultStatus.failure,
          errMessage: "Something not right"));
    }
  }

  void removeAddress(Address address) async {
    try {
      emit(state.copyWith(status: AddressStatus.loading));
      XResult<String> addressRes =
          await Domain().address.removeAddress(address);
      if (addressRes.isSuccess) {
        var localUser = await Domain().profile.getProfile();
        localUser.shippingAddress = localUser.shippingAddress - 1;
        XResult<EUser> resUser = await Domain().profile.saveProfile(localUser);
        if (resUser.isSuccess) {
          emit(state.copyWith(status: AddressStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              status: AddressStatus.failure, errMessage: resUser.error));
        }
      } else {
        emit(state.copyWith(
            status: AddressStatus.failure, errMessage: addressRes.error));
      }
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
        isDefault: address.isDefault));
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
