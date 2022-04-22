import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/domain.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    fetchCart();
  }

  void addToCart(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      var carts = await Domain().cart.addProductToCart(cartModel);
      var total = Domain().cart.getTotalPrice(state.salePercent);
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void removeCart(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      var carts = await Domain().cart.removeCart(cartModel);
      var total = Domain().cart.getTotalPrice(state.salePercent);
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void removeCartByOne(CartModel cartModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));

      var carts = await Domain().cart.removeCartByOne(cartModel);
      var total = Domain().cart.getTotalPrice(state.salePercent);
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
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
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void clearCodePromo() async {
    emit(state.copyWith(code: "", salePercent: 0));
    fetchCart();
  }

  void fetchCart() async {
    try {
      // emit(state.copyWith(status: FavoriteStatus.loading));
      // final Stream<XResult<List<FavoriteProduct>>> favoritesStream =
      //     Domain().favorite.getFavoritesStream();

      // favoriteSubscription = favoritesStream.listen((event) {
      //   emit(state.copyWith(
      //       status: FavoriteStatus.success, favorites: event.data));
      // });
      emit(state.copyWith(status: CartStatus.loading));
      final carts = await Domain().cart.getCarts();
      var total = Domain().cart.getTotalPrice(state.salePercent);
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }

  void clearCart() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      final carts = await Domain().cart.clearCarts();
      emit(state.copyWith(
          status: CartStatus.success,
          carts: carts,
          totalPrice: 0,
          code: "",
          salePercent: 0));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }
}
