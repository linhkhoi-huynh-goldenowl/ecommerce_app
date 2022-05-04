import 'package:e_commerce_shop_app/config/routes/router.dart';
import 'package:e_commerce_shop_app/modules/cubit/order/order_cubit.dart';
import 'package:e_commerce_shop_app/modules/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../config/styles/text_style.dart';
import '../../widgets/sliver_app_bar_delegate.dart';

import '../cubit/favorite/favorite_cubit.dart';

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
                  body: NestedScrollView(
                      physics: const BouncingScrollPhysics(),
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
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
                                    child: BlocBuilder<FavoriteCubit,
                                            FavoriteState>(
                                        buildWhen: (previous, current) =>
                                            previous.gridStatus !=
                                            current.gridStatus,
                                        builder: (context, state) {
                                          return BlocBuilder<OrderCubit,
                                              OrderState>(
                                            buildWhen: (previous, current) =>
                                                previous.orderSelect !=
                                                current.orderSelect,
                                            builder: (context, state) {
                                              return Container(
                                                color: const Color(0xffF9F9F9),
                                                height: 60,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    _tabButton(
                                                        state.orderSelect ==
                                                            OrderSelect
                                                                .delivered,
                                                        "Delivered", () {
                                                      context
                                                          .read<OrderCubit>()
                                                          .selectOption(
                                                              OrderSelect
                                                                  .delivered);
                                                    }),
                                                    _tabButton(
                                                        state.orderSelect ==
                                                            OrderSelect
                                                                .processing,
                                                        "Processing", () {
                                                      context
                                                          .read<OrderCubit>()
                                                          .selectOption(
                                                              OrderSelect
                                                                  .processing);
                                                    }),
                                                    _tabButton(
                                                        state.orderSelect ==
                                                            OrderSelect
                                                                .cancelled,
                                                        "Cancelled", () {
                                                      context
                                                          .read<OrderCubit>()
                                                          .selectOption(
                                                              OrderSelect
                                                                  .cancelled);
                                                    })
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        })),
                              ))
                        ];
                      },
                      body: BlocBuilder<OrderCubit, OrderState>(
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (context, state) {
                            return state.orders.isEmpty
                                ? const Center(
                                    child: Text("No Orders"),
                                  )
                                : _displayListView(state.orders, context);
                          }))),
            );

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
          left: top < MediaQuery.of(context).size.height * 0.13 ? 0 : 16,
          bottom: top < MediaQuery.of(context).size.height * 0.13 ? 12 : 0),
      centerTitle:
          top < MediaQuery.of(context).size.height * 0.13 ? true : false,
      title: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Text(
            "My Orders",
            textAlign: TextAlign.start,
            style: ETextStyle.metropolis(
                weight: top < MediaQuery.of(context).size.height * 0.13
                    ? FontWeight.w600
                    : FontWeight.w700,
                fontSize:
                    top < MediaQuery.of(context).size.height * 0.13 ? 22 : 27),
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

Widget _tabButton(bool isChoose, String title, VoidCallback func) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      primary: isChoose ? const Color(0xff222222) : const Color(0xffF9F9F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 0,
    ),
    onPressed: func,
    child: Text(title,
        style: ETextStyle.metropolis(
            fontSize: 14,
            color:
                isChoose ? const Color(0xfffbedec) : const Color(0xff222222))),
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
