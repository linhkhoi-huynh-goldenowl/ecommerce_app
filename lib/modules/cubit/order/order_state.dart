part of 'order_cubit.dart';

enum OrderStatus { initial, loading, success, failure }
enum AddressOrderStatus { initial, selected, unselected }
enum CreditOrderStatus { initial, selected, unselected }
enum DeliveryOrderStatus { initial, selected, unselected }
enum OrderSubmitStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  const OrderState(
      {this.orders = const [],
      this.status = OrderStatus.initial,
      this.deliveryId = "",
      this.addressStatus = AddressOrderStatus.initial,
      this.creditStatus = CreditOrderStatus.initial,
      this.deliveryStatus = DeliveryOrderStatus.initial,
      this.submitStatus = OrderSubmitStatus.initial,
      this.deliPrice = 0});
  final OrderStatus status;
  final List<Order> orders;
  final String deliveryId;
  final double deliPrice;
  final AddressOrderStatus addressStatus;
  final CreditOrderStatus creditStatus;
  final DeliveryOrderStatus deliveryStatus;
  final OrderSubmitStatus submitStatus;

  OrderState copyWith(
      {List<Order>? orders,
      OrderStatus? status,
      String? deliveryId,
      AddressOrderStatus? addressStatus,
      CreditOrderStatus? creditStatus,
      DeliveryOrderStatus? deliveryStatus,
      double? deliPrice,
      OrderSubmitStatus? submitStatus}) {
    return OrderState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        deliveryId: deliveryId ?? this.deliveryId,
        addressStatus: addressStatus ?? this.addressStatus,
        creditStatus: creditStatus ?? this.creditStatus,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        deliPrice: deliPrice ?? this.deliPrice,
        submitStatus: submitStatus ?? this.submitStatus);
  }

  @override
  List<Object> get props => [
        orders,
        status,
        deliveryId,
        addressStatus,
        creditStatus,
        deliveryStatus,
        deliPrice,
        submitStatus
      ];
}
