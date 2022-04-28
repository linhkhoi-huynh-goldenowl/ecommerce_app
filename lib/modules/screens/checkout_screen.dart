import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_app/config/routes/router.dart';
import 'package:e_commerce_app/config/styles/text_style.dart';
import 'package:e_commerce_app/modules/cubit/address/address_cubit.dart';
import 'package:e_commerce_app/modules/cubit/cart/cart_cubit.dart';
import 'package:e_commerce_app/modules/cubit/creditCard/credit_card_cubit.dart';
import 'package:e_commerce_app/modules/cubit/delivery/delivery_cubit.dart';
import 'package:e_commerce_app/modules/cubit/order/order_cubit.dart';
import 'package:e_commerce_app/modules/models/address.dart';
import 'package:e_commerce_app/modules/models/cart_model.dart';
import 'package:e_commerce_app/modules/models/credit_card.dart';
import 'package:e_commerce_app/utils/helpers/address_helpers.dart';
import 'package:e_commerce_app/utils/helpers/credit_helpers.dart';
import 'package:e_commerce_app/utils/helpers/show_snackbar.dart';
import 'package:e_commerce_app/widgets/button_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/delivery.dart';

// ignore: must_be_immutable
class CheckoutScreen extends StatelessWidget {
  CheckoutScreen(
      {Key? key,
      required this.carts,
      required this.promoId,
      required this.totalPrice,
      required this.contextBag})
      : super(key: key);
  final List<CartModel> carts;
  final String promoId;
  final double totalPrice;
  Address? address;
  CreditCard? card;
  final BuildContext contextBag;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AddressCubit>(
            create: (BuildContext context) => AddressCubit(),
          ),
          BlocProvider.value(
            value: BlocProvider.of<CartCubit>(contextBag),
          ),
          BlocProvider<CreditCardCubit>(
              create: (BuildContext context) => CreditCardCubit()),
          BlocProvider<DeliveryCubit>(
              create: (BuildContext context) => DeliveryCubit()),
          BlocProvider<OrderCubit>(
              create: (BuildContext context) => OrderCubit()),
        ],
        child: BlocConsumer<OrderCubit, OrderState>(
          listenWhen: (previous, current) =>
              previous.addressStatus != current.addressStatus ||
              previous.creditStatus != current.creditStatus ||
              previous.deliveryStatus != current.deliveryStatus ||
              previous.submitStatus != current.submitStatus,
          listener: (context, state) {
            if (state.addressStatus == AddressOrderStatus.unselected) {
              AppSnackBar.showSnackBar(context, "Please add address");
              context.read<OrderCubit>().setInitialAddress();
            }
            if (state.creditStatus == CreditOrderStatus.unselected) {
              AppSnackBar.showSnackBar(context, "Please add credit card");
              context.read<OrderCubit>().setInitialCredit();
            }
            if (state.deliveryStatus == DeliveryOrderStatus.unselected) {
              AppSnackBar.showSnackBar(context, "Please choose delivery");
              context.read<OrderCubit>().setInitialDelivery();
            }
            if (state.submitStatus == OrderSubmitStatus.success) {
              context.read<CartCubit>().clearCart();
              Navigator.of(context).pushNamed(Routes.orderSuccessScreen);
            }
          },
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.submitStatus != current.submitStatus,
          builder: (context, stateOrder) {
            return stateOrder.status == OrderStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
                    appBar: AppBar(
                        backgroundColor: const Color(0xffF9F9F9),
                        centerTitle: true,
                        leading: _leadingButton(context),
                        title: Text(
                          "Checkout",
                          style: ETextStyle.metropolis(
                              weight: FontWeight.w600, fontSize: 20),
                        )),
                    bottomNavigationBar: stateOrder.submitStatus ==
                            OrderSubmitStatus.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : bottomCheckBar(() {
                            if (address == null) {
                              context.read<OrderCubit>().setUnselectAddress();
                            } else if (card == null) {
                              context.read<OrderCubit>().setUnselectCredit();
                            } else if (stateOrder.deliveryId == "") {
                              context.read<OrderCubit>().setUnselectDelivery();
                            } else {
                              context.read<OrderCubit>().addOrder(
                                  carts,
                                  card!,
                                  address!,
                                  totalPrice,
                                  stateOrder.deliveryId,
                                  promoId);
                            }
                          }, totalPrice, stateOrder.deliPrice),
                    body: ListView(
                      padding:
                          const EdgeInsets.only(top: 32, left: 16, right: 16),
                      children: [
                        Text(
                          "Shipping address",
                          style: ETextStyle.metropolis(weight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 21,
                        ),
                        BlocBuilder<AddressCubit, AddressState>(
                            buildWhen: (previous, current) =>
                                previous.status != current.status,
                            builder: (context, stateAddress) {
                              if (stateAddress.status ==
                                  AddressStatus.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final defaultAddress =
                                    AddressHelper.getDefaultAddress(
                                        stateAddress.addresses);
                                if (defaultAddress == null) {
                                  return ButtonIntro(
                                    func: () {
                                      Navigator.of(context).pushNamed(
                                          Routes.shippingAddressScreen);
                                    },
                                    title: "Please add shipping address",
                                  );
                                } else {
                                  address = defaultAddress;
                                  return _addressCard(defaultAddress, () {
                                    Navigator.of(context).pushNamed(
                                        Routes.shippingAddressScreen);
                                  });
                                }
                              }
                            }),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment",
                              style: ETextStyle.metropolis(
                                  weight: FontWeight.w700),
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.paymentScreen);
                              },
                              child: Text(
                                "Change",
                                style: ETextStyle.metropolis(
                                    color: const Color(0xffDB3022),
                                    fontSize: 14,
                                    weight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                        BlocBuilder<CreditCardCubit, CreditCardState>(
                            buildWhen: (previous, current) =>
                                previous.status != current.status,
                            builder: (context, stateCredit) {
                              if (stateCredit.status ==
                                  CreditCardStatus.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final cardDefault =
                                    CreditCardHelper.getDefaultCreditCard(
                                        stateCredit.creditCards);
                                if (cardDefault == null) {
                                  return ButtonIntro(
                                    func: () {
                                      Navigator.of(context)
                                          .pushNamed(Routes.paymentScreen);
                                    },
                                    title: "Please add credit card",
                                  );
                                } else {
                                  card = cardDefault;
                                  return _creditCard(cardDefault);
                                }
                              }
                            }),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Delivery method",
                          style: ETextStyle.metropolis(weight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 115,
                            child: BlocBuilder<DeliveryCubit, DeliveryState>(
                                buildWhen: (previous, current) =>
                                    previous.status != current.status,
                                builder: (context, stateDeli) {
                                  if (stateDeli.status ==
                                      DeliveryStatus.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemBuilder: (context, index) {
                                        return _deliveryCard(
                                            stateDeli.deliveries[index], () {
                                          context
                                              .read<OrderCubit>()
                                              .setDelivery(
                                                  stateDeli.deliveries[index]
                                                          .id ??
                                                      "",
                                                  stateDeli.deliveries[index]
                                                      .shipPrice);
                                        },
                                            stateDeli.deliveries[index].id ==
                                                stateOrder.deliveryId);
                                      },
                                      itemCount: stateDeli.deliveries.length,
                                      scrollDirection: Axis.horizontal,
                                    );
                                  }
                                })),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ));
          },
        ));
  }
}

Widget bottomCheckBar(
    VoidCallback submit, double totalPrice, double deliPrice) {
  return BottomAppBar(
    elevation: 0,
    color: const Color(0xffF9F9F9),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order:",
                style: ETextStyle.metropolis(
                    color: const Color(0xff9B9B9B), fontSize: 14),
              ),
              Text(
                "${totalPrice.toStringAsFixed(0)}\$",
                style: ETextStyle.metropolis(weight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Delivery:",
                style: ETextStyle.metropolis(
                    color: const Color(0xff9B9B9B), fontSize: 14),
              ),
              Text(
                "${deliPrice.toStringAsFixed(0)}\$",
                style: ETextStyle.metropolis(weight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Summary:",
                style: ETextStyle.metropolis(
                    color: const Color(0xff9B9B9B), weight: FontWeight.w600),
              ),
              Text(
                "${(totalPrice + deliPrice).toStringAsFixed(0)}\$",
                style: ETextStyle.metropolis(
                    weight: FontWeight.w700, fontSize: 18),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonIntro(func: submit, title: "SUBMIT ORDER")
        ],
      ),
    ),
  );
}

Widget _leadingButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

Widget _addressCard(Address address, VoidCallback editAddress) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Stack(
      children: [
        Container(
          width: double.maxFinite,
          padding:
              const EdgeInsets.only(top: 18, left: 28, right: 23, bottom: 18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
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
              Text(
                address.fullName,
                style: ETextStyle.metropolis(
                    fontSize: 14, weight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                address.address,
                style: ETextStyle.metropolis(fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${address.city}, ${address.region} ${address.zipCode}, ${address.country}",
                style: ETextStyle.metropolis(fontSize: 14),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: editAddress,
              child: Text(
                "Change",
                style: ETextStyle.metropolis(
                    color: const Color(0xffDB3022),
                    fontSize: 14,
                    weight: FontWeight.w600),
              ),
            )),
      ],
    ),
  );
}

Widget _creditCard(CreditCard card) {
  return Row(
    children: [
      Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: card.cardNumber[0] == "5"
              ? Image.asset(
                  "assets/images/icons/mastercard_black.png",
                  scale: 6,
                )
              : Image.asset(
                  "assets/images/icons/visa_color.png",
                  scale: 13,
                )),
      const SizedBox(
        width: 16,
      ),
      Text(
        "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
        style: ETextStyle.metropolis(fontSize: 14, weight: FontWeight.w600),
      )
    ],
  );
}

Widget _deliveryCard(Delivery delivery, VoidCallback onTap, bool isChoose) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: isChoose ? Border.all(color: Colors.red, width: 5) : null,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 60, child: CachedNetworkImage(imageUrl: delivery.imgUrl)),
          Text(
            "${delivery.days} - ${delivery.days + 1} days",
            style: ETextStyle.metropolis(color: const Color(0xff9B9B9B)),
          )
        ],
      ),
    ),
  );
}
