import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/authentication/authentication_cubit.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:e_commerce_shop_app/utils/services/navigator_services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/models/product_item.dart';
import '../../modules/repositories/x_result.dart';

class DynamicLinkServices {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  static Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      BuildContext context = NavigationService.navigatorKey.currentContext!;
      bool checkLogin = context.read<AuthenticationCubit>().hasLogin();
      if (checkLogin) {
        List<String> separatedString = [];
        separatedString.addAll(dynamicLinkData.link.path.split('/'));
        if (separatedString[1] == "product") {
          XResult<ProductItem> productResult =
              await Domain().product.getProductById(separatedString[2]);
          if (productResult.isSuccess) {
            Navigator.of(context).pushNamed(Routes.productDetailsScreen,
                arguments: {
                  "contextParent": context,
                  "product": productResult.data
                });
          }
        }
      }
    });
  }

  static Future<String> buildDynamicLinkProduct(String id) async {
    String url = "https://fashionshopapp.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/product/$id'),
      androidParameters: const AndroidParameters(
        packageName: "com.goldenowl.e_commerce_shop_app",
      ),
    );

    final ShortDynamicLink dynamicUrl =
        await dynamicLinks.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }
}
