import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/address.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/credit_card.dart';
import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/order.dart';
import '../../repositories/domain.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  void fetchOrder() async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      var listOrders = await Domain().order.getOrders();

      emit(state.copyWith(status: OrderStatus.success, orders: listOrders));
    } catch (_) {
      emit(state.copyWith(status: OrderStatus.failure));
    }
  }

  void setDelivery(String id, double price) {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      emit(state.copyWith(
          status: OrderStatus.success,
          deliPrice: price,
          deliveryId: id,
          deliveryStatus: DeliveryOrderStatus.selected));
    } catch (_) {
      emit(state.copyWith(status: OrderStatus.failure));
    }
  }

  void addOrder(List<CartModel> listItems, CreditCard card, Address address,
      double totalPrice, String deliveryId, String promoId) async {
    try {
      emit(state.copyWith(submitStatus: OrderSubmitStatus.loading));

      Delivery delivery = await Domain().delivery.getDeliveryById(deliveryId);
      PromoModel? promoModel;
      if (promoId != "") {
        promoModel = await Domain().promo.getPromoById(promoId);
      }

      double totalAmount = totalPrice + delivery.shipPrice;

      Order order = Order(
          delivery: delivery,
          card: card,
          address: address,
          promoModel: promoModel,
          listItems: listItems,
          status: "processing",
          totalAmount: totalAmount);

      final orders = await Domain().order.addOrder(order);

      emit(state.copyWith(
          submitStatus: OrderSubmitStatus.success, orders: orders));
      emit(state.copyWith(submitStatus: OrderSubmitStatus.initial));
    } catch (_) {
      emit(state.copyWith(submitStatus: OrderSubmitStatus.failure));
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
