import 'package:e_commerce_shop_app/dialogs/avatar_change_image.dart';
import 'package:e_commerce_shop_app/dialogs/button_change_password.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_leading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/styles/text_style.dart';
import '../../widgets/appbars/flexible_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/textfields/text_field_widget.dart';
import '../cubit/profile/profile_cubit.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  _selectDate(BuildContext context, DateTime initDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(1950),
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
                body: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      _appBar(),
                    ];
                  },
                  body: Form(
                    key: state.formKey,
                    child: ListView(
                      children: [
                        _avatarChange(),
                        const SizedBox(
                          height: 23,
                        ),
                        _labelInfo(),
                        const SizedBox(
                          height: 23,
                        ),
                        _fullNameChange(),
                        const SizedBox(
                          height: 24,
                        ),
                        _dateOfBirthChange(),
                        const SizedBox(
                          height: 55,
                        ),
                        _passwordChange(),
                        _labelNotification(),
                        const SizedBox(
                          height: 12,
                        ),
                        _changeNotification(),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return const LoadingWidget();
          }
        });
  }

  Widget _appBar() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus,
      builder: (context, state) {
        return SliverAppBar(
            shadowColor: Colors.white,
            elevation: 5,
            backgroundColor: const Color(0xffF9F9F9),
            expandedHeight: 110.0,
            leading: const ButtonLeading(),
            pinned: true,
            stretch: true,
            actions: [
              state.saveStatus == SaveStatus.loading
                  ? const LoadingWidget()
                  : _saveButton(context, state.formKey)
            ],
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleAppBar(
              title: "Settings",
            ));
      },
    );
  }

  Widget _avatarChange() {
    return BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.imageStatus != current.imageStatus,
        builder: (context, state) {
          return AvatarChangeImage(
              imgUser: state.imageUrl,
              imgUrl: state.imageChangeUrl,
              funcGallery: () {
                context.read<ProfileCubit>().getImageFromGallery(context);
                Navigator.of(context, rootNavigator: true).pop(showDialog);
              },
              funcCamera: () {
                context.read<ProfileCubit>().getImageFromCamera(context);
                Navigator.of(context, rootNavigator: true).pop(showDialog);
              });
        });
  }

  Widget _passwordChange() {
    return BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.loginType != current.loginType,
        builder: (context, state) {
          return state.loginType == "facebook" || state.loginType == "google"
              ? const SizedBox()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _labelPassword(),
                    const SizedBox(
                      height: 21,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                );
        });
  }

  Widget _fullNameChange() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          return TextFieldWidget(
              initValue: state.name,
              labelText: "Full name",
              validatorText: "Incorrect Name",
              isValid: state.isValidName,
              func: ((value) =>
                  context.read<ProfileCubit>().settingNameChanged(value)),
              isPassword: false);
        },
      ),
    );
  }

  Widget _dateOfBirthChange() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFieldWidget(
            onTap: () => _selectDate(context, state.dateOfBirth),
            initValue: DateFormat('dd/MM/yyyy').format(state.dateOfBirth),
            labelText: "Date of birth",
            validatorText: "Incorrect Date",
            isValid: state.isValidDateOfBirth,
            func: ((value) =>
                context.read<ProfileCubit>().settingDateChanged(value)),
            isPassword: false,
            readOnly: true,
          ),
        );
      },
    );
  }

  Widget _changeNotification() {
    return BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.notificationSale != current.notificationSale ||
            previous.notificationNewArrivals !=
                current.notificationNewArrivals ||
            previous.notificationDelivery != current.notificationDelivery,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _switchNotification(
                  "Sales",
                  state.notificationSale,
                  (p0) => context
                      .read<ProfileCubit>()
                      .settingNotificationSale(!state.notificationSale)),
              _switchNotification(
                  "New arrivals",
                  state.notificationNewArrivals,
                  (p0) => context
                      .read<ProfileCubit>()
                      .settingNotificationNew(!state.notificationNewArrivals)),
              _switchNotification(
                  "Delivery status changes",
                  state.notificationDelivery,
                  (p0) => context
                      .read<ProfileCubit>()
                      .settingNotificationDelivery(
                          !state.notificationDelivery)),
            ],
          );
        });
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

  Widget _switchNotification(
      String title, bool value, Function(bool) onChanged) {
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
}
