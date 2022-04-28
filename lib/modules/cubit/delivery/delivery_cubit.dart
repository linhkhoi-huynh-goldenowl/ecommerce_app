import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/delivery.dart';
import 'package:e_commerce_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/x_result.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(const DeliveryState()) {
    fetchDeliveries();
  }

  void fetchDeliveries() async {
    try {
      emit(state.copyWith(status: DeliveryStatus.loading));
      XResult<List<Delivery>> deliRes = await Domain().delivery.getDeliveries();
      if (deliRes.isSuccess) {
        final listDeli = await Domain().delivery.setDeliveries(deliRes.data!);
        emit(state.copyWith(
            status: DeliveryStatus.success,
            deliveries: listDeli,
            errMessage: ""));
      } else {
        emit(state.copyWith(
            status: DeliveryStatus.failure, errMessage: deliRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: DeliveryStatus.failure, errMessage: "Something wrong"));
    }
  }
}
