part of 'order_cubit.dart';

enum OrderStatus { initial, loading, success, failure }
enum AddressOrderStatus { initial, selected, unselected }
enum CreditOrderStatus { initial, selected, unselected }
enum DeliveryOrderStatus { initial, selected, unselected }
enum OrderSubmitStatus { initial, loading, success, failure }
enum OrderSelect { delivered, processing, cancelled }
enum ReOrderStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  const OrderState(
      {this.orders = const [],
      this.status = OrderStatus.initial,
      this.deliveryId = "",
      this.addressStatus = AddressOrderStatus.initial,
      this.creditStatus = CreditOrderStatus.initial,
      this.deliveryStatus = DeliveryOrderStatus.initial,
      this.submitStatus = OrderSubmitStatus.initial,
      this.deliPrice = 0,
      this.orderSelect = OrderSelect.delivered,
      this.errMessage = "",
      this.reOrderStatus = ReOrderStatus.initial});
  final OrderStatus status;
  final List<Order> orders;
  final String deliveryId;
  final double deliPrice;
  final AddressOrderStatus addressStatus;
  final CreditOrderStatus creditStatus;
  final DeliveryOrderStatus deliveryStatus;
  final OrderSubmitStatus submitStatus;
  final OrderSelect orderSelect;
  final String errMessage;
  final ReOrderStatus reOrderStatus;

  OrderState copyWith(
      {List<Order>? orders,
      OrderStatus? status,
      String? deliveryId,
      AddressOrderStatus? addressStatus,
      CreditOrderStatus? creditStatus,
      DeliveryOrderStatus? deliveryStatus,
      double? deliPrice,
      OrderSubmitStatus? submitStatus,
      OrderSelect? orderSelect,
      String? errMessage,
      ReOrderStatus? reOrderStatus}) {
    return OrderState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        deliveryId: deliveryId ?? this.deliveryId,
        addressStatus: addressStatus ?? this.addressStatus,
        creditStatus: creditStatus ?? this.creditStatus,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        deliPrice: deliPrice ?? this.deliPrice,
        submitStatus: submitStatus ?? this.submitStatus,
        orderSelect: orderSelect ?? this.orderSelect,
        errMessage: errMessage ?? this.errMessage,
        reOrderStatus: reOrderStatus ?? this.reOrderStatus);
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
        submitStatus,
        orderSelect,
        errMessage,
        reOrderStatus
      ];
}
