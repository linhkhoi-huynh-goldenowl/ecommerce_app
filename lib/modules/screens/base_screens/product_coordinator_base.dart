// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:e_commerce_app/modules/models/order.dart';
import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:e_commerce_app/modules/screens/order_detail_screen.dart';
import 'package:e_commerce_app/modules/screens/product_details_screen.dart';
import 'package:e_commerce_app/modules/screens/setting_screen.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/router.dart';
import '../favorite_screen.dart';
import '../order_screen.dart';
import '../profile_screen.dart';
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

  void navigateDashboard() {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == Routes.dashboard;
    });
  }

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    String? routerName = settings.name;
    switch (routerName) {
      case Routes.shopCategoryScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ShopCategoryScreen());

      case Routes.settingScreen:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const SettingScreen());
      case Routes.orderScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const OrderScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => ProfileScreen());
      case Routes.favorite:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const FavoriteScreen());

      case Routes.productDetailsScreen:
        {
          final product = settings.arguments as ProductItem;
          return MaterialPageRoute(
              settings: settings,
              builder: (_) => ProductDetailsScreen(
                    productItem: product,
                  ));
        }
      case Routes.orderDetailScreen:
        {
          final argumentOrder = settings.arguments as Map;
          final BuildContext contextParent = argumentOrder['contextParent'];
          final Order order = argumentOrder['order'];
          return MaterialPageRoute(
              settings: settings,
              builder: (_) => OrderDetailScreen(
                    contextParent: contextParent,
                    order: order,
                  ));
        }

      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => buildInitialBody());
    }
  }
}
