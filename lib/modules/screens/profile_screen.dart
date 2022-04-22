import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/profile/profile_cubit.dart';
import 'package:e_commerce_shop_app/widgets/profile_info_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/routes/router.dart';
import '../../utils/services/navigator_services.dart';
import 'base_screens/product_coordinator_base.dart';

class ProfileScreen extends ProductCoordinatorBase {
  ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
        create: (BuildContext context) => ProfileCubit(),
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
                  child: Row(
                    children: [
                      state.imageUrl != ""
                          ? CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(state.imageUrl),
                              radius: 34,
                            )
                          : const CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                              radius: 44,
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
                    subTitle: "${state.shippingAddress} addresses",
                    func: () {
                      Navigator.of(
                              NavigationService.navigatorKey.currentContext ??
                                  context)
                          .pushNamed(Routes.shippingAddressScreen);
                    }),
                ProfileInfoButton(
                    title: "Payment methods",
                    subTitle: state.creditNumber.isEmpty
                        ? ''
                        : (state.creditNumber[0] == '4'
                            ? "Visa **${state.creditNumber.substring(state.creditNumber.length - 2)}"
                            : "Mastercard **${state.creditNumber.substring(state.creditNumber.length - 2)}"),
                    func: () {
                      Navigator.of(
                              NavigationService.navigatorKey.currentContext ??
                                  context)
                          .pushNamed(Routes.paymentScreen);
                    }),
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
                    func: () {
                      Navigator.of(context).pushNamed(Routes.settingScreen);
                    }),
                ProfileInfoButton(
                    title: "Sign out",
                    subTitle: "Log out of app",
                    func: () {
                      BlocProvider.of<AuthenticationCubit>(context)
                          .signOut(context, navigateLogin);
                    }),
              ],
            ),
          );
        });
  }
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}
