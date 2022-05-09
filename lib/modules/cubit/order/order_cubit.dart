import 'dart:async';

import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/e_user.dart';
import '../../models/order.dart';
import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState()) {
    fetchOrderDelivered();
    fetchOrderProcessing();
    fetchOrderCancelled();
  }
  StreamSubscription? orderDeliveredSubscription;
  StreamSubscription? orderProcessingSubscription;
  StreamSubscription? orderCancelledSubscription;
  @override
  Future<void> close() {
    orderDeliveredSubscription?.cancel();
    orderProcessingSubscription?.cancel();
    orderCancelledSubscription?.cancel();
    return super.close();
  }

  void fetchOrderDelivered() async {
    try {
      emit(state.copyWith(statusDelivered: OrderDeliveredStatus.loading));

      final Stream<XResult<List<Order>>> orderStream =
          await Domain().order.getOrderStream("Delivered");

      orderDeliveredSubscription = orderStream.listen((event) async {
        emit(state.copyWith(statusDelivered: OrderDeliveredStatus.loading));
        if (event.isSuccess) {
          final orders = event.data!;
          orders.sort(
            (a, b) =>
                b.createdDate!.toDate().compareTo(a.createdDate!.toDate()),
          );

          emit(state.copyWith(
              statusDelivered: OrderDeliveredStatus.success,
              errMessage: "",
              ordersDeli: orders));
        } else {
          emit(state.copyWith(
              statusDelivered: OrderDeliveredStatus.failure,
              errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          statusDelivered: OrderDeliveredStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void fetchOrderProcessing() async {
    try {
      emit(state.copyWith(statusProcessing: OrderProcessingStatus.loading));

      final Stream<XResult<List<Order>>> orderStream =
          await Domain().order.getOrderStream("Processing");

      orderProcessingSubscription = orderStream.listen((event) async {
        emit(state.copyWith(statusProcessing: OrderProcessingStatus.loading));
        if (event.isSuccess) {
          final orders = event.data!;
          orders.sort(
            (a, b) =>
                b.createdDate!.toDate().compareTo(a.createdDate!.toDate()),
          );

          emit(state.copyWith(
              statusProcessing: OrderProcessingStatus.success,
              errMessage: "",
              ordersProcess: orders));
        } else {
          emit(state.copyWith(
              statusProcessing: OrderProcessingStatus.failure,
              errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          statusProcessing: OrderProcessingStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void fetchOrderCancelled() async {
    try {
      emit(state.copyWith(statusCancelled: OrderCancelledStatus.loading));

      final Stream<XResult<List<Order>>> orderStream =
          await Domain().order.getOrderStream("Cancelled");

      orderCancelledSubscription = orderStream.listen((event) async {
        emit(state.copyWith(statusCancelled: OrderCancelledStatus.loading));
        if (event.isSuccess) {
          final orders = event.data!;
          orders.sort(
            (a, b) =>
                b.createdDate!.toDate().compareTo(a.createdDate!.toDate()),
          );

          emit(state.copyWith(
              statusCancelled: OrderCancelledStatus.success,
              errMessage: "",
              ordersCancel: orders));
        } else {
          emit(state.copyWith(
              statusCancelled: OrderCancelledStatus.failure,
              errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          statusCancelled: OrderCancelledStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void setDelivery(Delivery delivery) {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      emit(state.copyWith(
          status: OrderStatus.success,
          deliPrice: delivery.shipPrice,
          deliveryId: delivery.id,
          deliveryStatus: DeliveryOrderStatus.selected,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          status: OrderStatus.failure, errMessage: "Something wrong"));
    }
  }

  void reOrder(List<CartModel> carts, BuildContext context) async {
    try {
      emit(state.copyWith(reOrderStatus: ReOrderStatus.loading));
      XResult<String> res = await Domain().cart.reorderToCart(carts);
      if (res.isSuccess) {
        emit(state.copyWith(
            reOrderStatus: ReOrderStatus.success, errMessage: ""));
      } else {
        emit(state.copyWith(
            reOrderStatus: ReOrderStatus.failure, errMessage: res.error));
      }
    } catch (_) {
      emit(state.copyWith(
          reOrderStatus: ReOrderStatus.failure, errMessage: "Something wrong"));
    }
  }

  void addOrder(List<CartModel> listItems, CreditCard card, Address address,
      double totalPrice, PromoModel? promoModel, Delivery delivery) async {
    try {
      emit(state.copyWith(submitStatus: OrderSubmitStatus.loading));

      double totalAmount = totalPrice + delivery.shipPrice;

      Order order = Order(
          delivery: delivery,
          card: card,
          address: address,
          promoModel: promoModel,
          listItems: listItems,
          status: "Processing",
          totalAmount: totalAmount);

      XResult<Order> orderRes = await Domain().order.addOrder(order);
      if (orderRes.isSuccess) {
        var localUser = await Domain().profile.getProfile();
        localUser.orderCount = localUser.orderCount + 1;
        XResult<EUser> resUser = await Domain().profile.saveProfile(localUser);
        if (resUser.isSuccess) {
          emit(state.copyWith(submitStatus: OrderSubmitStatus.success));
          emit(state.copyWith(submitStatus: OrderSubmitStatus.initial));
        } else {
          emit(state.copyWith(
              submitStatus: OrderSubmitStatus.failure,
              errMessage: resUser.error));
        }
      } else {
        emit(state.copyWith(
            submitStatus: OrderSubmitStatus.failure,
            errMessage: orderRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          submitStatus: OrderSubmitStatus.failure,
          errMessage: "Something wrong"));
    }
  }

  void setUnselectAddress() async {
    emit(state.copyWith(addressStatus: AddressOrderStatus.unselected));
  }

  void setInitialAddress() async {
    emit(state.copyWith(addressStatus: AddressOrderStatus.initial));
  }

  void setUnselectCredit() async {
    emit(state.copyWith(creditStatus: CreditOrderStatus.unselected));
  }

  void setInitialCredit() async {
    emit(state.copyWith(creditStatus: CreditOrderStatus.initial));
  }

  void setUnselectDelivery() async {
    emit(state.copyWith(deliveryStatus: DeliveryOrderStatus.unselected));
  }

  void setInitialDelivery() async {
    emit(state.copyWith(deliveryStatus: DeliveryOrderStatus.initial));
  }
}
