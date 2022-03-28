part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  const ProfileState(
      {this.email = "",
      this.name = "",
      required this.dateOfBirth,
      this.shippingAddress = const <String>[],
      this.password = "",
      this.notificationSale = false,
      this.notificationNewArrivals = false,
      this.notificationDelivery = false,
      this.status = ProfileStatus.initial});
  final String email;
  final String name;
  final DateTime dateOfBirth;
  final List<String> shippingAddress;
  final String password;
  final bool notificationSale;
  final bool notificationNewArrivals;
  final bool notificationDelivery;

  final ProfileStatus status;
  ProfileState copyWith(
      {String? email,
      String? name,
      DateTime? dateOfBirth,
      List<String>? shippingAddress,
      String? password,
      bool? notificationSale,
      bool? notificationNewArrivals,
      bool? notificationDelivery,
      ProfileStatus? status}) {
    return ProfileState(
        email: email ?? this.email,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        password: password ?? this.password,
        notificationSale: notificationSale ?? this.notificationSale,
        notificationNewArrivals:
            notificationNewArrivals ?? this.notificationNewArrivals,
        notificationDelivery: notificationDelivery ?? this.notificationDelivery,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [
        email,
        name,
        dateOfBirth,
        shippingAddress,
        password,
        notificationSale,
        notificationNewArrivals,
        notificationDelivery,
        status
      ];
}
