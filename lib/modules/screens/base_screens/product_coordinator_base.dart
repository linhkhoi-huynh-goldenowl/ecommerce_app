import 'package:flutter/material.dart';

import '../../../config/routes/router.dart';
import '../shop_category_screen.dart';

abstract class ProductCoordinatorBase extends StatelessWidget {
  const ProductCoordinatorBase({Key? key}) : super(key: key);

  Widget buildInitialBody();

  Widget stackView(BuildContext context) {
    return Navigator(
      onGenerateRoute: onGenerateRoute,
    );
  }

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    String? routerName = settings.name;
    switch (routerName) {
      case Routes.shopCategoryScreen:
        return MaterialPageRoute(builder: (_) => const ShopCategoryScreen());
      default:
        return MaterialPageRoute(builder: (_) => buildInitialBody());
    }
  }
}
