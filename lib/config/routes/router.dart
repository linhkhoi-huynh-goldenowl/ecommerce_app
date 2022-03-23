import 'package:ecommerce_app/modules/screens/home_screen.dart';
import 'package:ecommerce_app/modules/screens/landing_page.dart';
import 'package:ecommerce_app/modules/screens/new_product_screen.dart';
import 'package:ecommerce_app/modules/screens/root_screen.dart';
import 'package:ecommerce_app/modules/screens/sale_product_screen.dart';
import 'package:ecommerce_app/modules/screens/shop_category_screen.dart';
import 'package:flutter/material.dart';
import '../../modules/screens/login_screen.dart';
import '../../modules/screens/sign_up_screen.dart';

class Routes {
  static const String landing = '/landingScreen';
  static const String home = '/HomeScreen';
  static const String dashboard = '/DashboardScreen';
  static const String logIn = '/LoginScreen';
  static const String signUp = '/SignUpScreen';
  static const String saleProduct = '/SaleProductScreen';
  static const String newProduct = '/NewProductScreen';
  static const String shopCategoryScreen = '/ShopCategoryScreen';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // arguments passed from pushName
    // dynamic args = settings.arguments;

    switch (settings.name) {
      case Routes.landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.logIn:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case Routes.saleProduct:
        return MaterialPageRoute(builder: (_) => const SaleProductScreen());
      case Routes.newProduct:
        return MaterialPageRoute(builder: (_) => const NewProductScreen());
      case Routes.shopCategoryScreen:
        return MaterialPageRoute(builder: (_) {
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