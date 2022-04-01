// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:e_commerce_app/modules/screens/landing_page.dart';
import 'package:e_commerce_app/modules/screens/login_screen.dart';
import 'package:e_commerce_app/modules/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/router.dart';
import '../shop_category_screen.dart';

abstract class ProductCoordinatorBase extends StatelessWidget {
  ProductCoordinatorBase({Key? key}) : super(key: key);
  late final BuildContext context;
  Widget buildInitialBody();
  Widget stackView(BuildContext context) {
    this.context = context;
    return Navigator(onGenerateRoute: onGenerateRoute);
  }

  void navigateLogin() {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == Routes.landing;
    });
  }

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    String? routerName = settings.name;
    switch (routerName) {
      case Routes.shopCategoryScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ShopCategoryScreen());
      case Routes.logIn:
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginScreen());
      case Routes.signUp:
        return MaterialPageRoute(
            settings: settings, builder: (_) => SignUpScreen());
      case Routes.landing:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LandingScreen());

      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => buildInitialBody());
    }
  }
}
