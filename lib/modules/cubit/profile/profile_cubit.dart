import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/e_user.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:e_commerce_app/utils/services/firebase_storage.dart';
import 'package:e_commerce_app/utils/services/image_picker_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repositories/x_result.dart';
import 'package:path/path.dart' as p;
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState(dateOfBirth: DateTime.now())) {
    profileLoaded();
    setLoginType();
  }

  void setLoginType() async {
    final pref = await SharedPreferences.getInstance();
    String? type = pref.getString("loginType");
    if (type != null) {
      emit(state.copyWith(loginType: type));
    }
  }

  void profileLoaded() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final profile = await Domain().profile.getProfile();

      emit(state.copyWith(
          id: profile.id,
          status: ProfileStatus.success,
          saveStatus: SaveStatus.initial,
          savePassStatus: SavePassStatus.initial,
          name: profile.name,
          imageUrl: profile.imageUrl,
          email: profile.email,
          dateOfBirth: profile.dateOfBirth,
          notificationDelivery: profile.notificationDelivery,
          notificationNewArrivals: profile.notificationNewArrivals,
          notificationSale: profile.notificationSale,
          shippingAddress: profile.shippingAddress));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
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
              dateOfBirth: state.dateOfBirth,
              shippingAddress: state.shippingAddress,
              notificationSale: state.notificationSale,
              notificationNewArrivals: state.notificationNewArrivals,
              notificationDelivery: state.notificationDelivery);

          await Domain().profile.saveProfile(user);
          emit(state.copyWith(
              status: ProfileStatus.success,
              saveStatus: SaveStatus.success,
              imageChangeUrl: ""));
          profileLoaded();
        } else {
          emit(state.copyWith(
              status: ProfileStatus.failure, saveStatus: SaveStatus.failure));
        }
      } else {
        final user = EUser(
            id: state.id,
            email: state.email,
            name: state.name,
            imageUrl: state.imageUrl,
            dateOfBirth: state.dateOfBirth,
            shippingAddress: state.shippingAddress,
            notificationSale: state.notificationSale,
            notificationNewArrivals: state.notificationNewArrivals,
            notificationDelivery: state.notificationDelivery);

        await Domain().profile.saveProfile(user);
        emit(state.copyWith(
            status: ProfileStatus.success, saveStatus: SaveStatus.success));
        profileLoaded();
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
      state.copyWith(status: ProfileStatus.loading),
    );
    emit(
      state.copyWith(notificationSale: switched, status: ProfileStatus.success),
    );
  }

  void settingNotificationNew(switched) {
    emit(
      state.copyWith(status: ProfileStatus.loading),
    );
    emit(
      state.copyWith(
          notificationNewArrivals: switched, status: ProfileStatus.success),
    );
  }

  void settingNotificationDelivery(switched) {
    emit(
      state.copyWith(status: ProfileStatus.loading),
    );
    emit(
      state.copyWith(
          notificationDelivery: switched, status: ProfileStatus.success),
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
        profileLoaded();
      }
    } on Exception {
      emit(state.copyWith(savePassStatus: SavePassStatus.failure));
    }
  }

  void getImageFromGallery() async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromGallery();
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageChangeUrl: imageUrl));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }

  void getImageFromCamera() async {
    try {
      emit(state.copyWith(imageStatus: ImageStatus.loading));
      final imageUrl = await ImagePickerService.handleImageFromCamera();
      emit(state.copyWith(
          imageStatus: ImageStatus.success, imageChangeUrl: imageUrl));
    } catch (_) {
      emit(state.copyWith(imageStatus: ImageStatus.failure));
    }
  }
}
