import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/profile/profile_cubit.dart';
import 'package:e_commerce_shop_app/widgets/e_cached_image.dart';
import 'package:e_commerce_shop_app/widgets/appbars/flexible_app_bar.dart';
import 'package:e_commerce_shop_app/widgets/buttons/profile_info_button.dart';
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
    return Scaffold(
        body: NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _appBar(),
        ];
      },
      body: ListView(
        children: [
          _showInfoProfile(),
          const SizedBox(
            height: 34,
          ),
          _orderButton(),
          _shippingButton(),
          _paymentButton(),
          _promoButton(),
          _reviewsUserButton(),
          _settingButton(),
          _signOutButton(),
        ],
      ),
    ));
  }

  Widget _appBar() {
    return const SliverAppBar(
        shadowColor: Colors.white,
        elevation: 5,
        backgroundColor: Color(0xffF9F9F9),
        expandedHeight: 110.0,
        pinned: true,
        stretch: true,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleAppBar(
          title: "My profile",
        ));
  }

  Widget _showInfoProfile() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.imageUrl != current.imageUrl ||
          previous.name != current.name ||
          previous.email != current.email,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(NavigationService.navigatorKey.currentContext ??
                          context)
                      .pushNamed(Routes.photoViewScreen, arguments: {
                    'paths': [state.imageUrl],
                    'index': 0
                  });
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: ECachedImage(
                          img: state.imageUrl != ""
                              ? state.imageUrl
                              : "https://www.chanchao.com.tw/VTG/images/default.jpg")),
                ),
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
        );
      },
    );
  }

  Widget _orderButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.orderCount != current.orderCount,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "My orders",
            subTitle: "Already have ${state.orderCount} orders",
            func: () {
              Navigator.of(context).pushNamed(Routes.orderScreen);
            });
      },
    );
  }

  Widget _shippingButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.shippingAddress != current.shippingAddress,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "Shipping addresses",
            subTitle: "${state.shippingAddress} addresses",
            func: () {
              Navigator.of(
                      NavigationService.navigatorKey.currentContext ?? context)
                  .pushNamed(Routes.shippingAddressScreen);
            });
      },
    );
  }

  Widget _paymentButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.creditNumber != current.creditNumber,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "Payment methods",
            subTitle: state.creditNumber == ""
                ? ''
                : (state.creditNumber[0] == '4'
                    ? "Visa **${state.creditNumber.substring(state.creditNumber.length - 2)}"
                    : "Mastercard **${state.creditNumber.substring(state.creditNumber.length - 2)}"),
            func: () {
              Navigator.of(
                      NavigationService.navigatorKey.currentContext ?? context)
                  .pushNamed(Routes.paymentScreen);
            });
      },
    );
  }

  Widget _promoButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "Promo codes",
            subTitle: "You have special promo codes",
            func: () {
              Navigator.of(context).pushNamed(Routes.promoListScreen);
            });
      },
    );
  }

  Widget _reviewsUserButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.reviewCount != current.reviewCount,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "My reviews",
            subTitle: "Reviews for ${state.reviewCount} items",
            func: () {
              Navigator.of(context).pushNamed(Routes.reviewListScreen);
            });
      },
    );
  }

  Widget _settingButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "Settings",
            subTitle: "Notification, password",
            func: () {
              Navigator.of(context).pushNamed(Routes.settingScreen);
            });
      },
    );
  }

  Widget _signOutButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ProfileInfoButton(
            title: "Sign out",
            subTitle: "Log out of app",
            func: () {
              BlocProvider.of<AuthenticationCubit>(context)
                  .signOut(context, navigateLogin);
            });
      },
    );
  }
}
