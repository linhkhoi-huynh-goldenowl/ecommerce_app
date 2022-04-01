import 'package:e_commerce_app/modules/screens/home_screen.dart';
import 'package:e_commerce_app/modules/screens/landing_page.dart';
import 'package:e_commerce_app/modules/screens/dashboard_screen.dart';
import 'package:e_commerce_app/modules/screens/profile_screen.dart';
import 'package:e_commerce_app/modules/screens/shop_category_screen.dart';
import 'package:e_commerce_app/modules/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import '../../modules/screens/login_screen.dart';
import '../../modules/screens/sign_up_screen.dart';

class Routes {
  static const String landing = '/LandingScreen';
  static const String home = '/HomeScreen';
  static const String dashboard = '/DashboardScreen';
  static const String logIn = '/LoginScreen';
  static const String signUp = '/SignUpScreen';
  static const String shopCategoryScreen = '/ShopCategoryScreen';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // arguments passed from pushName
    // dynamic args = settings.arguments;

    switch (settings.name) {
      case Routes.landing:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const LandingScreen());
      case Routes.dashboard:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const DashboardScreen());
      case Routes.home:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => HomeScreen());
      case Routes.logIn:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => LoginScreen());
      case Routes.signUp:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => SignUpScreen());
      case Routes.shopCategoryScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              return const ShopCategoryScreen();
            });
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Feature is in development')),
                ));
    }
  }
}
