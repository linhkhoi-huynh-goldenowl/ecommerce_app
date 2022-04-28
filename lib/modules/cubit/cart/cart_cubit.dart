import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/cart_model.dart';
import 'package:e_commerce_app/modules/models/promo_model.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/domain.dart';
import '../../repositories/x_result.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    fetchCart();
  }
  StreamSubscription? cartSubscription;
  @override
  Future<void> close() {
    cartSubscription?.cancel();
    return super.close();
  }

  void addToCart(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      XResult<CartModel> cartsRes =
          await Domain().cart.addProductToCart(cartModel);
      if (cartsRes.isSuccess) {
        emit(state.copyWith(status: CartStatus.success, errMessage: ""));
      } else {
        emit(state.copyWith(
            status: CartStatus.failure, errMessage: cartsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void removeCart(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      XResult<String> cartsRes = await Domain().cart.removeCart(cartModel);
      if (cartsRes.isSuccess) {
        emit(state.copyWith(status: CartStatus.success, errMessage: ""));
      } else {
        emit(state.copyWith(
            status: CartStatus.failure, errMessage: cartsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void removeCartByOne(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      if (cartModel.quantity > 1) {
        XResult<CartModel> cartsRes =
            await Domain().cart.removeCartByOne(cartModel);
        if (cartsRes.isSuccess) {
          emit(state.copyWith(status: CartStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              status: CartStatus.failure, errMessage: cartsRes.error));
        }
      } else {
        removeCart(cartModel);
      }
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void setPromoToCart(String code) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      PromoModel promoModel = await Domain().promo.getPromoById(code);
      emit(state.copyWith(
          status: CartStatus.success,
          salePercent: promoModel.salePercent,
          code: code));
      fetchCart();
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void clearCodePromo() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      var total = Domain().cart.getTotalPrice(0);
      emit(state.copyWith(
          status: CartStatus.success,
          totalPrice: total,
          code: "",
          salePercent: 0,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void fetchCart() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final Stream<XResult<List<CartModel>>> cartStream =
          await Domain().cart.getCartStream();

      cartSubscription = cartStream.listen((event) async {
        emit(state.copyWith(status: CartStatus.loading));
        if (event.isSuccess) {
          final carts = await Domain().cart.setCarts(event.data!);
          var total = Domain().cart.getTotalPrice(state.salePercent);
          emit(state.copyWith(
              status: CartStatus.success,
              carts: carts,
              totalPrice: total,
              errMessage: ""));
        } else {
          emit(state.copyWith(
              status: CartStatus.failure, carts: [], errMessage: event.error));
        }
      });
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void clearCart() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      XResult<String> cartsRes = await Domain().cart.clearCarts();
      if (cartsRes.isSuccess) {
        emit(state.copyWith(
            status: CartStatus.success,
            totalPrice: 0,
            code: "",
            salePercent: 0));
      } else {
        emit(state.copyWith(
            status: CartStatus.failure, errMessage: cartsRes.error));
      }
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }
}
