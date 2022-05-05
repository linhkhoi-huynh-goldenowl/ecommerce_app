import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/product_item.dart';
import 'package:e_commerce_shop_app/modules/screens/add_address_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/checkout_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/favorite_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/landing_page.dart';
import 'package:e_commerce_shop_app/modules/screens/dashboard_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/order_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/payment_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/photo_view_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/product_details_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/product_rating_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/profile_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/reset_pass_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/setting_screen.dart';
import 'package:e_commerce_shop_app/modules/screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import '../../modules/screens/login_screen.dart';
import '../../modules/screens/order_success_screen.dart';
import '../../modules/screens/sign_up_screen.dart';

class Routes {
  static const String landing = '/LandingScreen';
  static const String home = '/HomeScreen';
  static const String dashboard = '/DashboardScreen';
  static const String logIn = '/LoginScreen';
  static const String signUp = '/SignUpScreen';
  static const String favorite = '/FavoriteScreen';
  static const String shopCategoryScreen = '/ShopCategoryScreen';
  static const String settingScreen = '/SettingScreen';
  static const String productDetailsScreen = '/ProductDetailsScreen';
  static const String productRatingScreen = '/ProductRatingScreen';
  static const String shippingAddressScreen = '/ShippingAddressScreen';
  static const String addAddressScreen = '/AddAddressScreen';
  static const String checkoutScreen = '/CheckoutScreen';
  static const String paymentScreen = '/PaymentScreen';
  static const String profileScreen = '/ProfileScreen';
  static const String orderSuccessScreen = "/OrderSuccessScreen";
  static const String orderScreen = "/OrderScreen";
  static const String orderDetailScreen = "/OrderDetailScreen";
  static const String resetPassScreen = "/ResetPassScreen";
  static const String promoListScreen = "/PromoListScreen";
  static const String reviewListScreen = "/ReviewListSCreen";
  static const String photoViewScreen = "/PhotoViewScreen";
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
      case Routes.favorite:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const FavoriteScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => ProfileScreen());
      case Routes.settingScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const SettingScreen());
      case Routes.orderSuccessScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => OrderSuccessScreen());
      case Routes.orderScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const OrderScreen());
      case Routes.checkoutScreen:
        final argumentOrder = settings.arguments as Map;
        final List<CartModel> carts = argumentOrder['carts'];
        final String promoId = argumentOrder['promoId'];
        final double totalPrice = argumentOrder['totalPrice'];
        final BuildContext contextBag = argumentOrder['contextBag'];
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => CheckoutScreen(
                contextBag: contextBag,
                carts: carts,
                promoId: promoId,
                totalPrice: totalPrice));
      case Routes.paymentScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const PaymentScreen());
      case Routes.shippingAddressScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => const ShippingAddressScreen());

      case Routes.addAddressScreen:
        final argumentAddress = settings.arguments as Map;
        final addressId = argumentAddress['addressId'];
        final BuildContext contextParent = argumentAddress['context'];
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => AddAddressScreen(
                  addressId: addressId,
                  contextParent: contextParent,
                ));
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
      case Routes.resetPassScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) => ResetPassScreen());
      case Routes.photoViewScreen:
        {
          final argumentPhoto = settings.arguments as Map;
          final List<String> paths = argumentPhoto['paths'];
          final int index = argumentPhoto['index'];
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) => PhotoViewScreen(
                    galleryItems: paths,
                    initialIndex: index,
                  ));
        }
      case Routes.productDetailsScreen:
        {
          final argumentDetail = settings.arguments as Map;
          final BuildContext contextParent = argumentDetail['contextParent'];
          final ProductItem product = argumentDetail['product'];
          return MaterialPageRoute(
              settings: settings,
              builder: (_) => ProductDetailsScreen(
                    contextParent: contextParent,
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
