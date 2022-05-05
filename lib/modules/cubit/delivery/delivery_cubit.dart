import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/x_result.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(const DeliveryState()) {
    fetchDeliveries();
  }
  StreamSubscription? deliverySubscription;
  @override
  Future<void> close() {
    deliverySubscription?.cancel();
    return super.close();
  }

  void fetchDeliveries() async {
    try {
      emit(state.copyWith(status: DeliveryStatus.loading));
      final Stream<XResult<List<Delivery>>> deliveryStream =
          await Domain().delivery.getDeliveriesStream();

      deliverySubscription = deliveryStream.listen((event) async {
        emit(state.copyWith(status: DeliveryStatus.loading));
        if (event.isSuccess) {
          emit(state.copyWith(
              status: DeliveryStatus.success,
              deliveries: event.data,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: DeliveryStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: DeliveryStatus.failure, errMessage: "Something wrong"));
    }
  }

  Delivery getDeliveryById(String id) {
    return state.deliveries.firstWhere((element) => element.id == id);
  }
}
