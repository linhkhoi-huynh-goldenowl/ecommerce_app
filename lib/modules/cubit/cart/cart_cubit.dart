import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/modules/models/cart_model.dart';
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
      var total = Domain().cart.getTotalPrice();
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
      var total = Domain().cart.getTotalPrice();
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
      var total = Domain().cart.getTotalPrice();
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
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
      var total = Domain().cart.getTotalPrice();
      emit(state.copyWith(
          status: CartStatus.success, carts: carts, totalPrice: total));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.failure));
    }
  }
}
