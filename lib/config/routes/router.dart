import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/screens/landing_page.dart';
import 'package:e_commerce_app/modules/screens/dashboard_screen.dart';
import 'package:e_commerce_app/modules/screens/product_details_screen.dart';
import 'package:e_commerce_app/modules/screens/product_rating_screen.dart';
import 'package:e_commerce_app/modules/screens/setting_screen.dart';
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
  static const String settingScreen = '/SettingScreen';
  static const String productDetailsScreen = '/ProductDetailsScreen';
  static const String productRatingScreen = '/ProductRatingScreen';
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

      case Routes.logIn:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => LoginScreen());
      case Routes.signUp:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => SignUpScreen());

      case Routes.settingScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const SettingScreen());
      case Routes.productRatingScreen:
        final argumentProduct = settings.arguments as Map;
        final String productId = argumentProduct['productId'];
        final BuildContext contextParent = argumentProduct['context'];
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => ProductRatingScreen(
                  contextParent: contextParent,
                  productId: productId,
                ));
      case Routes.productDetailsScreen:
        {
          final product = settings.arguments as ProductItem;
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => ProductDetailsScreen(
                    productItem: product,
                  ));
        }

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Feature is in development')),
                ));
    }
  }
}
