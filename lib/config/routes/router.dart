import 'package:ecommerce_app/modules/screens/dashboard_screen.dart';
import 'package:ecommerce_app/modules/screens/new_product_screen.dart';
import 'package:ecommerce_app/modules/screens/sale_product_screen.dart';
import 'package:flutter/material.dart';

import '../../modules/screens/login/login_screen.dart';
import '../../modules/screens/sign_up/sign_up_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/DashboardScreen':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/LoginScreen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/SignUpScreen':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/SaleProductScreen':
        return MaterialPageRoute(builder: (_) => const SaleProductScreen());
      case '/NewProductScreen':
        return MaterialPageRoute(builder: (_) => const NewProductScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
