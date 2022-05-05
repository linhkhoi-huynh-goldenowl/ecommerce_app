import 'package:e_commerce_shop_app/config/styles/text_style.dart';
import 'package:e_commerce_shop_app/modules/cubit/navigation/navigation_cubit.dart';
import 'package:e_commerce_shop_app/modules/cubit/order/order_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:e_commerce_shop_app/modules/models/order.dart';
import 'package:e_commerce_shop_app/utils/helpers/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../utils/helpers/product_helpers.dart';
import '../../widgets/color_size_widget.dart';
import '../../widgets/image_product_widget.dart';
import '../../widgets/loading_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({
    Key? key,
    required this.order,
    required this.contextParent,
  }) : super(key: key);
  final Order order;
  final BuildContext contextParent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<OrderCubit>(contextParent),
      child: BlocConsumer<OrderCubit, OrderState>(
        listenWhen: (previous, current) =>
            previous.reOrderStatus != current.reOrderStatus,
        listener: (context, state) {
          if (state.reOrderStatus == ReOrderStatus.failure) {
            AppSnackBar.showSnackBar(context, state.errMessage);
          }
          if (state.reOrderStatus == ReOrderStatus.success) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            BlocProvider.of<NavigationCubit>(context)
                .getNavBarItem(NavbarItem.bag);
          }
        },
        buildWhen: (previous, current) =>
            previous.reOrderStatus != current.reOrderStatus,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color(0xffF9F9F9),
                  centerTitle: true,
                  leading: _leadingButton(context),
                  actions: [_findButton()],
                  title: Text(
                    "Order Details",
                    style: ETextStyle.metropolis(
                        weight: FontWeight.w600, fontSize: 18),
                  )),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 22, top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order No${order.id!.substring(order.id!.length - 6)}",
                          style: ETextStyle.metropolis(weight: FontWeight.w600),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy')
                              .format(order.createdDate!.toDate()),
                          style: ETextStyle.metropolis(
                              color: const Color(0xff9B9B9B), fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Tracking number: ',
                                  style: ETextStyle.metropolis(
                                    fontSize: 14,
                                    color: const Color(0xff9B9B9B),
                                  )),
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              TextSpan(
                                  text: "IW3475453455",
                                  style: ETextStyle.metropolis(
                                      color: const Color(0xff222222),
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Text(
                          order.status,
                          style: ETextStyle.metropolis(
                              fontSize: 14,
                              color: order.status == "Delivered"
                                  ? const Color(0xff2AA952)
                                  : order.status == "Cancelled"
                                      ? const Color(0xffDB3022)
                                      : Colors.amber),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: Text(
                      "${order.listItems.length} items",
                      style: ETextStyle.metropolis(
                          weight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: order.listItems.length > 2
                        ? MediaQuery.of(context).size.height * 0.5
                        : order.listItems.length > 1
                            ? 280
                            : 150,
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 12, left: 16, right: 16),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _itemCard(order.listItems[index]);
                      },
                      itemCount: order.listItems.length,
                    ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Order information",
                      style: ETextStyle.metropolis(
                          weight: FontWeight.w600, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(5),
                      },
                      children: [
                        buildTableRow("Shipping Address:",
                            "${order.address.address}, ${order.address.city}, ${order.address.region} ${order.address.zipCode}, ${order.address.country}"),
                        TableRow(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(bottom: 27),
                                child: Text("Payment method:",
                                    style: ETextStyle.metropolis(
                                      fontSize: 14,
                                      color: const Color(0xff9B9B9B),
                                    )),
                                alignment: Alignment.centerLeft),
                            Container(
                                margin: const EdgeInsets.only(bottom: 27),
                                child: _creditItem(order.card))
                          ],
                        ),
                        buildTableRow("Delivery:",
                            "${order.delivery.name}, ${order.delivery.days} days, ${order.delivery.shipPrice.toStringAsFixed(0)}\$"),
                        buildTableRow(
                            "Discount:",
                            order.promoModel != null
                                ? "${order.promoModel!.salePercent.toStringAsFixed(0)}%, ${order.promoModel!.name} code"
                                : "Not use"),
                        buildTableRow("Total Amount:",
                            "${order.totalAmount.toStringAsFixed(0)}\$"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: state.reOrderStatus == ReOrderStatus.loading
                                ? const LoadingWidget()
                                : _buttonReorder(() {
                                    BlocProvider.of<OrderCubit>(context)
                                        .reOrder(order.listItems, context);
                                  })),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: _buttonFeedback(() {}))
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

Widget _buttonReorder(VoidCallback func) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      primary: const Color(0xffFFFFFF),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xff222222)),
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 0,
    ),
    onPressed: func,
    child: Text("Reorder",
        style: ETextStyle.metropolis(
            fontSize: 14, color: const Color(0xff222222))),
  );
}

Widget _buttonFeedback(VoidCallback func) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      primary: const Color(0xffDB3022),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 3,
    ),
    onPressed: func,
    child: Text("Leave feedback",
        style: ETextStyle.metropolis(
            fontSize: 14, color: const Color(0xffffffff))),
  );
}

TableRow buildTableRow(
  String _title,
  String _value,
) {
  return TableRow(
    children: [
      Container(
          margin: const EdgeInsets.only(bottom: 27),
          child: Text(_title,
              style: ETextStyle.metropolis(
                fontSize: 14,
                color: const Color(0xff9B9B9B),
              )),
          alignment: Alignment.centerLeft),
      Container(
        margin: const EdgeInsets.only(bottom: 27),
        child: Text(_value,
            style: ETextStyle.metropolis(
                color: const Color(0xff222222),
                fontSize: 14,
                weight: FontWeight.w600)),
        alignment: Alignment.centerLeft,
      ),
    ],
  );
}

Widget _creditItem(CreditCard card) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      card.cardNumber[0] == "5"
          ? Image.asset(
              "assets/images/icons/mastercard_black.png",
              scale: 6,
            )
          : Image.asset(
              "assets/images/icons/visa_color.png",
              scale: 13,
            ),
      const SizedBox(
        width: 15,
      ),
      Text(
        "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
        style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
      )
    ],
  );
}

Widget _itemCard(CartModel cartModel) {
  return Container(
    height: 104,
    width: double.maxFinite,
    margin: const EdgeInsets.only(bottom: 24),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Row(
      children: [
        ImageProductWidget(
            isGrid: false,
            imagePath: cartModel.productItem.images[0],
            width: 104,
            height: 104,
            radius: 20),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 11, top: 11, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cartModel.productItem.title,
                    style: ETextStyle.metropolis(weight: FontWeight.bold)),
                Text(
                  cartModel.productItem.brandName,
                  style: ETextStyle.metropolis(
                      fontSize: 11, color: const Color(0xff9B9B9B)),
                ),
                ColorSizeWidget(color: cartModel.color, size: cartModel.size),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Units:',
                              style: ETextStyle.metropolis(
                                fontSize: 14,
                                color: const Color(0xff9B9B9B),
                              )),
                          const WidgetSpan(
                            child: SizedBox(
                              width: 5,
                            ),
                          ),
                          TextSpan(
                              text: cartModel.quantity.toString(),
                              style: ETextStyle.metropolis(
                                  color: const Color(0xff222222),
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    Text(
                      "${ProductHelper.getPriceWithSaleItem(cartModel.productItem, cartModel.color, cartModel.size).toStringAsFixed(0)}\$",
                      style: ETextStyle.metropolis(
                          fontSize: 14, weight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
