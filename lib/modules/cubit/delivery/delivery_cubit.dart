import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/delivery.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  DeliveryCubit() : super(const DeliveryState()) {
    fetchDeliveries();
  }

  void fetchDeliveries() async {
    try {
      emit(state.copyWith(status: DeliveryStatus.loading));
      var listDeli = await Domain().delivery.getDeliveries();

      emit(
          state.copyWith(status: DeliveryStatus.success, deliveries: listDeli));
    } catch (_) {
      emit(state.copyWith(status: DeliveryStatus.failure));
    }
  }
}
