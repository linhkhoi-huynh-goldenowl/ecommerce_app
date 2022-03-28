import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_app/modules/cubit/profile/profile_cubit.dart';
import 'package:e_commerce_app/modules/repositories/profile_repository.dart';
import 'package:e_commerce_app/widgets/profile_info_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_screens/product_coordinator_base.dart';

class ProfileScreen extends ProductCoordinatorBase {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
        create: (BuildContext context) =>
            ProfileCubit(profileRepository: ProfileRepository()),
        child: stackView(context));
  }

  @override
  Widget buildInitialBody() {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocBuilder<ProfileCubit, ProfileState>(
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
                  actions: [_findButton()],
                  elevation: 0,
                  backgroundColor: const Color(0xffF9F9F9),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "My profile",
                        style: ETextStyle.metropolis(
                            fontSize: 34, weight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/carousel2.jpg"),
                            radius: 34,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  state.name,
                                  style: ETextStyle.metropolis(
                                      weight: FontWeight.w600, fontSize: 18),
                                ),
                              ),
                              Text(
                                state.email,
                                style: ETextStyle.metropolis(
                                    weight: FontWeight.w600,
                                    fontSize: 14,
                                    color: const Color(0xff9B9B9B)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 34,
                    ),
                    ProfileInfoButton(
                        title: "My orders",
                        subTitle: "Already have 12 orders",
                        func: () {}),
                    ProfileInfoButton(
                        title: "Shipping addresses",
                        subTitle: "3 addresses",
                        func: () {}),
                    ProfileInfoButton(
                        title: "Payment methods",
                        subTitle: "Visa **34",
                        func: () {}),
                    ProfileInfoButton(
                        title: "Promo codes",
                        subTitle: "You have special promo codes",
                        func: () {}),
                    ProfileInfoButton(
                        title: "My reviews",
                        subTitle: "Reviews for 4 items",
                        func: () {}),
                    ProfileInfoButton(
                        title: "Settings",
                        subTitle: "Notification, password",
                        func: () {}),
                    ProfileInfoButton(
                        title: "Sign out",
                        subTitle: "Log out of app",
                        func: () {
                          BlocProvider.of<AuthenticationCubit>(context)
                              .signOut();
                        }),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}
