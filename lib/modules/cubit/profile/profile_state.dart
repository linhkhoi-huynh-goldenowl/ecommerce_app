part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

enum SaveStatus { initial, loading, success, failure }
enum SavePassStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  ProfileState(
      {this.id = "",
      this.email = "",
      this.name = "",
      required this.dateOfBirth,
      this.shippingAddress = const <String>[],
      this.notificationSale = false,
      this.notificationNewArrivals = false,
      this.notificationDelivery = false,
      this.status = ProfileStatus.initial,
      this.saveStatus = SaveStatus.initial,
      this.oldPassword = "",
      this.newPassword = "",
      this.newPasswordConfirm = "",
      this.loginType = "",
      this.savePassStatus = SavePassStatus.initial,
      this.savePassMessage = ""});

  bool get isValidName => name.length > 3;
  bool get isValidDateOfBirth => dateOfBirth.isBefore(DateTime.now());

  final String id;
  final String email;
  final String name;
  final DateTime dateOfBirth;
  final List<String> shippingAddress;
  final bool notificationSale;
  final bool notificationNewArrivals;
  final bool notificationDelivery;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProfileStatus status;

  final String oldPassword;
  bool get isValidOldPassword => oldPassword.length > 6;
  final String newPassword;
  bool get isValidNewPassword => newPassword.length > 6;
  final String newPasswordConfirm;
  bool get isValidConfirmPassword =>
      newPasswordConfirm.compareTo(newPassword) == 0;
  final SaveStatus saveStatus;
  final SavePassStatus savePassStatus;
  final String savePassMessage;
  final String loginType;
  ProfileState copyWith(
      {String? id,
      String? email,
      String? name,
      DateTime? dateOfBirth,
      List<String>? shippingAddress,
      bool? notificationSale,
      bool? notificationNewArrivals,
      bool? notificationDelivery,
      ProfileStatus? status,
      SaveStatus? saveStatus,
      String? oldPassword,
      String? newPassword,
      String? newPasswordConfirm,
      String? loginType,
      SavePassStatus? savePassStatus,
      String? savePassMessage}) {
    return ProfileState(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        notificationSale: notificationSale ?? this.notificationSale,
        notificationNewArrivals:
            notificationNewArrivals ?? this.notificationNewArrivals,
        notificationDelivery: notificationDelivery ?? this.notificationDelivery,
        status: status ?? this.status,
        saveStatus: saveStatus ?? this.saveStatus,
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
        newPasswordConfirm: newPasswordConfirm ?? this.newPasswordConfirm,
        loginType: loginType ?? this.loginType,
        savePassStatus: savePassStatus ?? this.savePassStatus,
        savePassMessage: savePassMessage ?? this.savePassMessage);
  }

  @override
  List<Object> get props => [
        id,
        email,
        name,
        dateOfBirth,
        shippingAddress,
        notificationSale,
        notificationNewArrivals,
        notificationDelivery,
        status,
        saveStatus,
        formKey,
        oldPassword,
        newPassword,
        newPasswordConfirm,
        loginType,
        savePassStatus,
        savePassMessage
      ];
}
