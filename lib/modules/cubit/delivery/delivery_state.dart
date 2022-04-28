part of 'delivery_cubit.dart';

enum DeliveryStatus { initial, loading, success, failure }

class DeliveryState extends Equatable {
  const DeliveryState(
      {this.deliveries = const [],
      this.status = DeliveryStatus.initial,
      this.errMessage = ""});

  final List<Delivery> deliveries;
  final DeliveryStatus status;
  final String errMessage;
  DeliveryState copyWith(
      {List<Delivery>? deliveries,
      DeliveryStatus? status,
      String? errMessage}) {
    return DeliveryState(
        status: status ?? this.status,
        deliveries: deliveries ?? this.deliveries,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object> get props => [deliveries, status, errMessage];
}
