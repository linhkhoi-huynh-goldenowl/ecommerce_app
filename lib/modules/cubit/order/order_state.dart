part of 'order_cubit.dart';

enum OrderStatus { initial, loading, success, failure }
enum OrderDeliveredStatus { initial, loading, success, failure }
enum OrderProcessingStatus { initial, loading, success, failure }
enum OrderCancelledStatus { initial, loading, success, failure }
enum AddressOrderStatus { initial, selected, unselected }
enum CreditOrderStatus { initial, selected, unselected }
enum DeliveryOrderStatus { initial, selected, unselected }
enum OrderSubmitStatus { initial, loading, success, failure }
enum OrderSelect { delivered, processing, cancelled }
enum ReOrderStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  const OrderState(
      {this.ordersDeli = const [],
      this.ordersProcess = const [],
      this.ordersCancel = const [],
      this.status = OrderStatus.initial,
      this.statusDelivered = OrderDeliveredStatus.initial,
      this.statusProcessing = OrderProcessingStatus.initial,
      this.statusCancelled = OrderCancelledStatus.initial,
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
  final OrderDeliveredStatus statusDelivered;
  final OrderProcessingStatus statusProcessing;
  final OrderCancelledStatus statusCancelled;
  final List<Order> ordersDeli;
  final List<Order> ordersProcess;
  final List<Order> ordersCancel;
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
      {List<Order>? ordersDeli,
      List<Order>? ordersProcess,
      List<Order>? ordersCancel,
      OrderStatus? status,
      OrderDeliveredStatus? statusDelivered,
      OrderProcessingStatus? statusProcessing,
      OrderCancelledStatus? statusCancelled,
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
        statusDelivered: statusDelivered ?? this.statusDelivered,
        statusProcessing: statusProcessing ?? this.statusProcessing,
        statusCancelled: statusCancelled ?? this.statusCancelled,
        ordersDeli: ordersDeli ?? this.ordersDeli,
        ordersProcess: ordersProcess ?? this.ordersProcess,
        ordersCancel: ordersCancel ?? this.ordersCancel,
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
        status,
        deliveryId,
        addressStatus,
        creditStatus,
        deliveryStatus,
        deliPrice,
        submitStatus,
        orderSelect,
        errMessage,
        reOrderStatus,
        ordersDeli,
        ordersProcess,
        ordersCancel,
        statusDelivered,
        statusProcessing,
        statusCancelled
      ];
}
