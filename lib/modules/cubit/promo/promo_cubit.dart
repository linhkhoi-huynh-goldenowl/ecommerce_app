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

  void fetchPromos() async {
    try {
      emit(state.copyWith(status: PromoStatus.loading));
      XResult<List<PromoModel>> promosRes = await Domain().promo.getPromotion();
      if (promosRes.isSuccess) {
        final promos = await Domain().promo.setPromotion(promosRes.data ?? []);
        emit(state.copyWith(
            status: PromoStatus.success,
            promos: promos,
            errMessage: promosRes.error));
      }
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
}
