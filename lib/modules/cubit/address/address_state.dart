part of 'address_cubit.dart';

enum AddressStatus {
  initial,
  success,
  failure,
  loading,
}
enum AddressTypeStatus { initial, typing, typed, submitting, submitted }

enum AddressDefaultStatus {
  initial,
  success,
  failure,
  loading,
}

class AddressState extends Equatable {
  const AddressState(
      {this.fullName = "",
      this.address = "",
      this.city = "",
      this.region = "",
      this.zipCode = "",
      this.country = "",
      this.status = AddressStatus.initial,
      this.typeStatus = AddressTypeStatus.initial,
      this.addresses = const [],
      this.isDefault = false,
      this.defaultStatus = AddressDefaultStatus.initial});

  final String fullName;
  bool get isFullNameValid => fullName.length > 2;

  final String address;
  bool get isAddressValid => address.length > 6;

  final String city;
  bool get isCityValid => city.length > 3;

  final String region;
  bool get isRegionValid => region.length > 6;

  final String zipCode;
  bool get isZipCodeValid => zipCode.length > 4;

  final String country;
  bool get isCountryValid => country != "";

  final bool isDefault;

  final AddressTypeStatus typeStatus;

  final AddressStatus status;
  final AddressDefaultStatus defaultStatus;

  final List<Address> addresses;

  AddressState copyWith(
      {String? fullName,
      String? address,
      String? city,
      String? region,
      String? zipCode,
      String? country,
      AddressStatus? status,
      AddressTypeStatus? typeStatus,
      List<Address>? addresses,
      AddressDefaultStatus? defaultStatus,
      bool? isDefault}) {
    return AddressState(
        status: status ?? this.status,
        fullName: fullName ?? this.fullName,
        address: address ?? this.address,
        city: city ?? this.city,
        region: region ?? this.region,
        zipCode: zipCode ?? this.zipCode,
        country: country ?? this.country,
        addresses: addresses ?? this.addresses,
        typeStatus: typeStatus ?? this.typeStatus,
        isDefault: isDefault ?? this.isDefault,
        defaultStatus: defaultStatus ?? this.defaultStatus);
  }

  @override
  List<Object> get props => [
        fullName,
        address,
        city,
        region,
        zipCode,
        country,
        status,
        addresses,
        typeStatus,
        isDefault,
        defaultStatus
      ];
}
