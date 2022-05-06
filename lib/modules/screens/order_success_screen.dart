import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/widgets/buttons/button_intro.dart';
import 'package:flutter/material.dart';

import 'base_screens/product_coordinator_base.dart';

class OrderSuccessScreen extends ProductCoordinatorBase {
  OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return stackView(context);
  }

  @override
  Widget buildInitialBody() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset("assets/images/order_complete.png",
                      fit: BoxFit.cover)),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Success!",
                style: ETextStyle.metropolis(
                    fontSize: 34, weight: FontWeight.w700),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Your order will be delivered soon. Thank you for choosing our app!",
                style: ETextStyle.metropolis(fontSize: 14),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonIntro(
                func: () {
                  navigateDashboard();
                },
                title: "Continue Shopping"),
          ),
        ),
      ),
    );
  }
}
