import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/profile/profile_cubit.dart';
import 'package:e_commerce_shop_app/widgets/e_cached_image.dart';
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
              body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    shadowColor: Colors.white,
                    elevation: 5,
                    backgroundColor: const Color(0xffF9F9F9),
                    expandedHeight: 110.0,
                    pinned: true,
                    stretch: true,
                    automaticallyImplyLeading: false,
                    flexibleSpace: _flexibleSpaceBar()),
              ];
            },
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(NavigationService
                                      .navigatorKey.currentContext ??
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
                              child: ECachedImage(img: state.imageUrl)),
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
                ),
                const SizedBox(
                  height: 34,
                ),
                ProfileInfoButton(
                    title: "My orders",
                    subTitle: "Already have ${state.orderCount} orders",
                    func: () {
                      Navigator.of(context).pushNamed(Routes.orderScreen);
                    }),
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
                    func: () {
                      Navigator.of(context).pushNamed(Routes.promoListScreen);
                    }),
                ProfileInfoButton(
                    title: "My reviews",
                    subTitle: "Reviews for ${state.reviewCount} items",
                    func: () {
                      Navigator.of(context).pushNamed(Routes.reviewListScreen);
                    }),
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
          ));
        });
  }
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}

Widget _flexibleSpaceBar() {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    var top = constraints.biggest.height;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
          left: top < MediaQuery.of(context).size.height * 0.13 ? 0 : 16,
          bottom: top < MediaQuery.of(context).size.height * 0.13 ? 15 : 0),
      centerTitle:
          top < MediaQuery.of(context).size.height * 0.13 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Text(
            "My profile",
            textAlign: TextAlign.start,
            style: ETextStyle.metropolis(
                weight: top < MediaQuery.of(context).size.height * 0.13
                    ? FontWeight.w600
                    : FontWeight.w700,
                fontSize:
                    top < MediaQuery.of(context).size.height * 0.13 ? 22 : 27),
          )),
    );
  });
}
