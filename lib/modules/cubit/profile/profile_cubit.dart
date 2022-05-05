import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/e_user.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:e_commerce_shop_app/utils/services/firebase_storage.dart';
import 'package:e_commerce_shop_app/utils/services/image_picker_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/x_result.dart';
import 'package:path/path.dart' as p;
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState(dateOfBirth: DateTime(1950))) {
    fetchProfile();
    setLoginType();
  }
  StreamSubscription? profileSubscription;

  @override
  Future<void> close() {
    profileSubscription?.cancel();
    return super.close();
  }

  void setLoginType() async {
    final pref = await SharedPreferences.getInstance();
    String? type = pref.getString("loginType");
    if (type != null) {
      emit(state.copyWith(loginType: type));
    }
  }

  void fetchProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getString("userId");
      final Stream<DocumentSnapshot<EUser>> profileStream =
          Domain().profile.getProfileStream(userId!);

      profileSubscription = profileStream.listen((event) async {
        emit(state.copyWith(status: ProfileStatus.loading));
        if (event.data() != null) {
          Domain().profile.setCurrentUser(event.data()!);
          final profile = await Domain().profile.getProfile();
          emit(state.copyWith(
              id: profile.id,
              status: ProfileStatus.success,
              saveStatus: SaveStatus.initial,
              savePassStatus: SavePassStatus.initial,
              name: profile.name,
              imageUrl: profile.imageUrl,
              creditNumber: profile.creditDefault,
              email: profile.email,
              dateOfBirth: profile.dateOfBirth,
              notificationDelivery: profile.notificationDelivery,
              notificationNewArrivals: profile.notificationNewArrivals,
              notificationSale: profile.notificationSale,
              shippingAddress: profile.shippingAddress,
              orderCount: profile.orderCount,
              reviewCount: profile.reviewCount));
        } else {
          emit(state.copyWith(
              status: ProfileStatus.failure,
              errMessage: "Can not get profile data"));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: ProfileStatus.failure, errMessage: "Something not right"));
    }
  }

  void saveProfile() async {
    try {
      emit(state.copyWith(
          status: ProfileStatus.loading, saveStatus: SaveStatus.loading));
      if (state.imageChangeUrl != "") {
        XResult result = await FirebaseStorageService().uploadToFirebase(
            state.imageChangeUrl,
            "${state.email}-${DateTime.now().toIso8601String()}${p.extension(state.imageChangeUrl)}");
        if (result.isSuccess) {
          final user = EUser(
              id: state.id,
              email: state.email,
              name: state.name,
              imageUrl: result.data,
              orderCount: state.orderCount,
              dateOfBirth: state.dateOfBirth,
              creditDefault: state.creditNumber,
              shippingAddress: state.shippingAddress,
              notificationSale: state.notificationSale,
              notificationNewArrivals: state.notificationNewArrivals,
              notificationDelivery: state.notificationDelivery,
              reviewCount: state.reviewCount);

          await Domain().profile.saveProfile(user);
          emit(state.copyWith(
              status: ProfileStatus.success,
              saveStatus: SaveStatus.success,
              imageChangeUrl: ""));
        } else {
          emit(state.copyWith(
              status: ProfileStatus.failure,
              saveStatus: SaveStatus.failure,
              errMessage: result.error));
        }
      } else {
        final user = EUser(
            id: state.id,
            email: state.email,
            name: state.name,
            imageUrl: state.imageUrl,
            orderCount: state.orderCount,
            reviewCount: state.reviewCount,
            dateOfBirth: state.dateOfBirth,
            creditDefault: state.creditNumber,
            shippingAddress: state.shippingAddress,
            notificationSale: state.notificationSale,
            notificationNewArrivals: state.notificationNewArrivals,
            notificationDelivery: state.notificationDelivery);

        XResult<EUser> res = await Domain().profile.saveProfile(user);
        if (res.isSuccess) {
          emit(state.copyWith(
              status: ProfileStatus.success, saveStatus: SaveStatus.success));
        } else {
          emit(state.copyWith(
              status: ProfileStatus.failure,
              saveStatus: SaveStatus.failure,
              errMessage: res.error));
        }
      }
    } catch (_) {
      emit(state.copyWith(
          status: ProfileStatus.failure, saveStatus: SaveStatus.failure));
    }
  }

  void settingNameChanged(name) {
    emit(
      state.copyWith(name: name),
    );
  }

  void settingDateChanged(date) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await Future.delayed(const Duration(milliseconds: 10));
      emit(
        state.copyWith(dateOfBirth: date, status: ProfileStatus.success),
      );
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  void settingNotificationSale(switched) {
    emit(
      state.copyWith(notificationSale: switched),
    );
  }

  void settingNotificationNew(switched) {
    emit(
      state.copyWith(notificationNewArrivals: switched),
    );
  }

  void settingNotificationDelivery(switched) {
    emit(
      state.copyWith(notificationDelivery: switched),
    );
  }

  void settingOldPasswordChanged(oldPassword) async {
    emit(
      state.copyWith(oldPassword: oldPassword),
    );
  }

  void settingNewPasswordChanged(newPassword) async {
    emit(
      state.copyWith(newPassword: newPassword),
    );
  }

  void settingConfirmNewPasswordChanged(newPasswordConfirm) async {
    emit(
      state.copyWith(newPasswordConfirm: newPasswordConfirm),
    );
  }

  void changePassword(String email, String oldPass, String newPassword) async {
    try {
      emit(state.copyWith(savePassStatus: SavePassStatus.loading));
      XResult result =
          await Domain().profile.changePassword(email, oldPass, newPassword);

      if (result.isError) {
        emit(state.copyWith(
            savePassStatus: SavePassStatus.failure,
            savePassMessage: result.error));
      } else {
        emit(state.copyWith(savePassStatus: SavePassStatus.success));
      }
    } on Exception {
      emit(state.copyWith(savePassStatus: SavePassStatus.failure));
    }
  }

  void getImageFromGallery(BuildContext context) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromGallery(context);
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageChangeUrl: imageUrl));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }

  void getImageFromCamera(BuildContext context) async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromCamera(context);
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageChangeUrl: imageUrl));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }
}
