part of 'delivery_cubit.dart';

enum DeliveryStatus { initial, loading, success, failure }

class DeliveryState extends Equatable {
  const DeliveryState(
      {this.deliveries = const [], this.status = DeliveryStatus.initial});

  final List<Delivery> deliveries;
  final DeliveryStatus status;
  DeliveryState copyWith({List<Delivery>? deliveries, DeliveryStatus? status}) {
    return DeliveryState(
        status: status ?? this.status,
        deliveries: deliveries ?? this.deliveries);
  }

  @override
  List<Object> get props => [deliveries, status];
}
