import 'package:e_commerce_app/dialogs/avatar_change_image.dart';
import 'package:e_commerce_app/dialogs/button_change_password.dart';
import 'package:e_commerce_app/utils/helpers/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/styles/text_style.dart';
import '../../widgets/text_field_widget.dart';
import '../cubit/profile/profile_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  _selectDate(BuildContext context, DateTime initDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initDate) {
      context.read<ProfileCubit>().settingDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            previous.saveStatus != current.saveStatus,
        listener: (context, state) {
          if (state.saveStatus == SaveStatus.success) {
            AppSnackBar.showSnackBar(context, "Save information success");
          }
          if (state.saveStatus == SaveStatus.failure) {
            AppSnackBar.showSnackBar(context, "Save information fail");
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case ProfileStatus.failure:
              return const Scaffold(
                body: Center(child: Text('Failed To Get Profile')),
              );
            case ProfileStatus.success:
              return Scaffold(
                appBar: AppBar(
                  leading: _leadingButton(context),
                  actions: [
                    state.saveStatus == SaveStatus.loading
                        ? const CircularProgressIndicator()
                        : _saveButton(context, state.formKey)
                  ],
                  elevation: 0,
                  backgroundColor: const Color(0xffF9F9F9),
                ),
                body: Form(
                  key: state.formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Settings",
                          style: ETextStyle.metropolis(
                              fontSize: 34, weight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      BlocBuilder<ProfileCubit, ProfileState>(
                          buildWhen: (previous, current) =>
                              previous.imageStatus != current.imageStatus,
                          builder: (context, state) {
                            return AvatarChangeImage(
                                imgUser: state.imageUrl,
                                imgUrl: state.imageChangeUrl,
                                funcGallery: () {
                                  context
                                      .read<ProfileCubit>()
                                      .getImageFromGallery();
                                },
                                funcCamera: () {
                                  context
                                      .read<ProfileCubit>()
                                      .getImageFromCamera();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(showDialog);
                                });
                          }),
                      const SizedBox(
                        height: 23,
                      ),
                      _labelInfo(),
                      const SizedBox(
                        height: 23,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            return TextFieldWidget(
                                initValue: state.name,
                                labelText: "Full name",
                                validatorText: "Incorrect Name",
                                isValid: state.isValidName,
                                func: ((value) => context
                                    .read<ProfileCubit>()
                                    .settingNameChanged(value)),
                                isPassword: false);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFieldWidget(
                          onTap: () => _selectDate(context, state.dateOfBirth),
                          initValue: DateFormat('dd/MM/yyyy')
                              .format(state.dateOfBirth),
                          labelText: "Date of birth",
                          validatorText: "Incorrect Date",
                          isValid: state.isValidDateOfBirth,
                          func: ((value) => context
                              .read<ProfileCubit>()
                              .settingDateChanged(value)),
                          isPassword: false,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      state.loginType == "facebook" ||
                              state.loginType == "google"
                          ? const SizedBox()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _labelPassword(),
                                const SizedBox(
                                  height: 21,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextFieldWidget(
                                    initValue: "**************",
                                    labelText: "Password",
                                    validatorText: "",
                                    isValid: true,
                                    func: (value) {},
                                    isPassword: true,
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 55,
                                ),
                              ],
                            ),
                      _labelNotification(),
                      const SizedBox(
                        height: 12,
                      ),
                      _switchNotification(
                          "Sales",
                          state.notificationSale,
                          (p0) => context
                              .read<ProfileCubit>()
                              .settingNotificationSale(
                                  !state.notificationSale)),
                      _switchNotification(
                          "New arrivals",
                          state.notificationNewArrivals,
                          (p0) => context
                              .read<ProfileCubit>()
                              .settingNotificationNew(
                                  !state.notificationNewArrivals)),
                      _switchNotification(
                          "Delivery status changes",
                          state.notificationDelivery,
                          (p0) => context
                              .read<ProfileCubit>()
                              .settingNotificationDelivery(
                                  !state.notificationDelivery)),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget _saveButton(BuildContext context, GlobalKey<FormState> formKey) {
  return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<ProfileCubit>().saveProfile();
        }
      },
      icon: const ImageIcon(
        AssetImage("assets/images/icons/check.png"),
        color: Color(0xff222222),
        size: 24,
      ));
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      context.read<ProfileCubit>().profileLoaded();
      Navigator.pop(context);
    },
  );
}

Widget _labelPassword() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Password",
          style: ETextStyle.metropolis(weight: FontWeight.w600),
        ),
        ButtonChangePassword()
      ],
    ),
  );
}

Widget _labelInfo() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      "Personal Information",
      style: ETextStyle.metropolis(weight: FontWeight.w600),
    ),
  );
}

Widget _labelNotification() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      "Notifications",
      style: ETextStyle.metropolis(weight: FontWeight.w600),
    ),
  );
}

Widget _switchNotification(String title, bool value, Function(bool) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: ETextStyle.metropolis(weight: FontWeight.w500, fontSize: 14),
        ),
        Transform.scale(
          child: CupertinoSwitch(value: value, onChanged: onChanged),
          scale: 0.8,
        )
      ],
    ),
  );
}
