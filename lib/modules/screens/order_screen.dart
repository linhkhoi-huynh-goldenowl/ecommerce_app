import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/order/order_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/styles/text_style.dart';
import '../../widgets/sliver_app_bar_delegate.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (BuildContext context) => OrderCubit(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case OrderStatus.failure:
            return const Scaffold(
              body: Center(child: Text('Failed To Get orders')),
            );

          case OrderStatus.success:
            return GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                child: Scaffold(
                  body: DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverAppBar(
                              shadowColor: Colors.white,
                              elevation: 5,
                              backgroundColor: const Color(0xffF9F9F9),
                              expandedHeight: 110.0,
                              pinned: true,
                              stretch: true,
                              leading: _leadingButton(context),
                              flexibleSpace: _flexibleSpaceBar(),
                              actions: [_findButton()]),
                          SliverPersistentHeader(
                              pinned: true,
                              delegate: SliverAppBarDelegate(
                                child: PreferredSize(
                                    preferredSize: const Size.fromHeight(60.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      color: const Color(0xffF9F9F9),
                                      height: 60,
                                      child: TabBar(
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        labelColor: const Color(0xffFFFFFF),
                                        unselectedLabelColor:
                                            const Color(0xff222222),
                                        indicatorColor: Colors.transparent,
                                        isScrollable: false,
                                        labelPadding: EdgeInsets.zero,
                                        indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: const Color(0xff222222)),
                                        tabs: [
                                          _tabButton("Delivered"),
                                          _tabButton("Processing"),
                                          _tabButton("Cancelled"),
                                        ],
                                      ),
                                    )),
                              ))
                        ];
                      },
                      body: TabBarView(
                        children: [
                          BlocBuilder<OrderCubit, OrderState>(
                              buildWhen: (previous, current) =>
                                  previous.ordersDeli != current.ordersDeli,
                              builder: (context, state) {
                                return state.ordersDeli.isEmpty
                                    ? const Center(
                                        child: Text("No Orders"),
                                      )
                                    : _displayListView(
                                        state.ordersDeli, context);
                              }),
                          BlocBuilder<OrderCubit, OrderState>(
                              buildWhen: (previous, current) =>
                                  previous.ordersProcess !=
                                  current.ordersProcess,
                              builder: (context, state) {
                                return state.ordersProcess.isEmpty
                                    ? const Center(
                                        child: Text("No Orders"),
                                      )
                                    : _displayListView(
                                        state.ordersProcess, context);
                              }),
                          BlocBuilder<OrderCubit, OrderState>(
                              buildWhen: (previous, current) =>
                                  previous.ordersCancel != current.ordersCancel,
                              builder: (context, state) {
                                return state.ordersCancel.isEmpty
                                    ? const Center(
                                        child: Text("No Orders"),
                                      )
                                    : _displayListView(
                                        state.ordersCancel, context);
                              })
                        ],
                      ),
                    ),
                  ),
                ));

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

ListView _displayListView(List orders, BuildContext context) {
  return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int index) {
        return _orderCard(orders[index], () {
          Navigator.of(context).pushNamed(Routes.orderDetailScreen,
              arguments: {'order': orders[index], 'contextParent': context});
        });
      },
      itemCount: orders.length);
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget _findButton() {
  return IconButton(
      onPressed: () {}, icon: Image.asset('assets/images/icons/find.png'));
}

Widget _flexibleSpaceBar() {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    var top = constraints.biggest.height;
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(
          left: top < MediaQuery.of(context).size.height * 0.12 ? 0 : 16,
          bottom: top < MediaQuery.of(context).size.height * 0.12 ? 12 : 0),
      centerTitle:
          top < MediaQuery.of(context).size.height * 0.12 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Text(
            "My Orders",
            textAlign: TextAlign.start,
            style: ETextStyle.metropolis(
                weight: top < MediaQuery.of(context).size.height * 0.12
                    ? FontWeight.w600
                    : FontWeight.w700,
                fontSize:
                    top < MediaQuery.of(context).size.height * 0.12 ? 22 : 27),
          )),
    );
  });
}

Widget _orderCard(Order order, VoidCallback func) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order No${order.id!.substring(order.id!.length - 6)}",
              style: ETextStyle.metropolis(weight: FontWeight.w600),
            ),
            Text(
              DateFormat('dd-MM-yyyy').format(order.createdDate!.toDate()),
              style: ETextStyle.metropolis(
                  color: const Color(0xff9B9B9B), fontSize: 14),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
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
                      color: const Color(0xff222222), fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(
          height: 11,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Quantity: ',
                      style: ETextStyle.metropolis(
                        fontSize: 14,
                        color: const Color(0xff9B9B9B),
                      )),
                  TextSpan(
                      text: order.listItems.length.toString(),
                      style: ETextStyle.metropolis(
                          color: const Color(0xff222222), fontSize: 14)),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Amount: ',
                      style: ETextStyle.metropolis(
                        fontSize: 14,
                        color: const Color(0xff9B9B9B),
                      )),
                  TextSpan(
                      text: "${order.totalAmount.toStringAsFixed(0)}\$",
                      style: ETextStyle.metropolis(
                          color: const Color(0xff222222),
                          fontSize: 14,
                          weight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 17,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buttonDetails(func),
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
        )
      ],
    ),
  );
}

Widget _tabButton(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      title,
      style: const TextStyle(fontFamily: "Metropolis", fontSize: 14),
    ),
  );
}

Widget _buttonDetails(VoidCallback func) {
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
    child: Text("Details",
        style: ETextStyle.metropolis(
            fontSize: 14, color: const Color(0xff222222))),
  );
}
