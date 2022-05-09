import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:e_commerce_shop_app/modules/repositories/domain.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/x_result.dart';

part 'promo_state.dart';

class PromoCubit extends Cubit<PromoState> {
  PromoCubit() : super(const PromoState()) {
    fetchPromos();
  }
  StreamSubscription? promoSubscription;
  @override
  Future<void> close() {
    promoSubscription?.cancel();
    return super.close();
  }

  void fetchPromos() async {
    try {
      emit(state.copyWith(status: PromoStatus.loading));
      final Stream<XResult<List<PromoModel>>> promoStream =
          await Domain().promo.getPromotionStream();

      promoSubscription = promoStream.listen((event) async {
        emit(state.copyWith(status: PromoStatus.loading));
        if (event.isSuccess) {
          final promos = event.data!
              .where((element) =>
                  element.endDate.toDate().compareTo(DateTime.now()) >= 0)
              .toList();
          emit(state.copyWith(
              status: PromoStatus.success,
              promos: promos,
              errMessage: event.error));
        } else {
          emit(state.copyWith(
              status: PromoStatus.failure, errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: PromoStatus.failure, errMessage: "Something wrong"));
    }
  }

  void codeInputChanged(String code) {
    emit(state.copyWith(codeInput: code, codeStatus: CodePromoStatus.typing));
    if (state.isValidCodeInput) {
      emit(state.copyWith(codeStatus: CodePromoStatus.typed));
    } else {
      emit(state.copyWith(codeStatus: CodePromoStatus.typing));
    }
  }

  PromoModel getPromoById(String code) {
    return state.promos.firstWhere((element) => element.id == code);
  }

  bool checkContainPromo(String code) {
    return state.promos
        .where((element) => element.id == code)
        .toList()
        .isNotEmpty;
  }
}
