import 'package:e_commerce_shop_app/modules/cubit/profile/profile_cubit.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_shop_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/styles/text_style.dart';
import '../widgets/buttons/button_intro.dart';
import '../widgets/textfields/text_field_widget.dart';

class ButtonChangePassword extends StatelessWidget {
  ButtonChangePassword({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet<void>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          context: context,
          builder: (BuildContext context) {
            return BlocProvider.value(
              value: BlocProvider.of<ProfileCubit>(context),
              child: BlocListener<ProfileCubit, ProfileState>(
                  listenWhen: (previous, current) =>
                      previous.savePassStatus != current.savePassStatus,
                  listener: (context, state) {
                    if (state.savePassStatus == SavePassStatus.success) {
                      AppSnackBar.showSnackBar(context, "Save successfully");
                      Navigator.pop(context);
                    }
                    if (state.savePassStatus == SavePassStatus.failure) {
                      AppSnackBar.showSnackBar(context, state.savePassMessage);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 14,
                          ),
                          Image.asset(
                            "assets/images/icons/rectangle.png",
                            scale: 3,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                              child: ListView(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Password Change",
                                  style: ETextStyle.metropolis(fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  buildWhen: (previous, current) =>
                                      previous.isValidOldPassword !=
                                      current.isValidOldPassword,
                                  builder: (context, state) {
                                    return TextFieldWidget(
                                      labelText: "Old Password",
                                      validatorText: "",
                                      isValid: state.isValidOldPassword,
                                      func: (value) => context
                                          .read<ProfileCubit>()
                                          .settingOldPasswordChanged(value),
                                      isPassword: true,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: ETextStyle.metropolis(
                                            color: const Color(0xff9B9B9B)),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              BlocBuilder<ProfileCubit, ProfileState>(
                                buildWhen: (previous, current) =>
                                    previous.newPassword != current.newPassword,
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: TextFieldWidget(
                                      labelText: "New Password",
                                      validatorText:
                                          "Password must than 6 character",
                                      isValid: state.isValidNewPassword,
                                      func: (value) => context
                                          .read<ProfileCubit>()
                                          .settingNewPasswordChanged(value),
                                      isPassword: true,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  buildWhen: (previous, current) =>
                                      previous.newPasswordConfirm !=
                                      current.newPasswordConfirm,
                                  builder: (context, state) {
                                    return TextFieldWidget(
                                      labelText: "Repeat New Password",
                                      validatorText:
                                          "Repeat password must equal new password",
                                      isValid: state.isValidConfirmPassword,
                                      func: (value) => context
                                          .read<ProfileCubit>()
                                          .settingConfirmNewPasswordChanged(
                                              value),
                                      isPassword: true,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  buildWhen: (previous, current) =>
                                      previous.oldPassword !=
                                          current.oldPassword ||
                                      previous.newPasswordConfirm !=
                                          current.newPasswordConfirm ||
                                      previous.savePassStatus !=
                                          current.savePassStatus,
                                  builder: (context, state) {
                                    if (state.savePassStatus ==
                                        SavePassStatus.loading) {
                                      return const LoadingWidget();
                                    } else {
                                      return ButtonIntro(
                                          func: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<ProfileCubit>()
                                                  .changePassword(
                                                      state.email,
                                                      state.oldPassword,
                                                      state.newPasswordConfirm);
                                            }
                                          },
                                          title: "SAVE PASSWORD");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  )),
            );
          },
        );
      },
      child: Text(
        "Change",
        style:
            ETextStyle.metropolis(fontSize: 14, color: const Color(0xff9B9B9B)),
      ),
    );
  }
}
