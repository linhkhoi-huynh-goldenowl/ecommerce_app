import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce_shop_app/modules/models/cart_model.dart';
import 'package:e_commerce_shop_app/modules/models/promo_model.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/helpers/product_helpers.dart';
import '../../models/favorite_product.dart';
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
      final pref = await SharedPreferences.getInstance();
      final userId = pref.getString("userId");
      cartModel.userId = userId;
      cartModel.id = "$userId-${cartModel.productItem.id}- ${cartModel.size}";
      int indexCart = _getIndexContainList(cartModel);
      if (indexCart > -1) {
        cartModel.quantity += 1;
        XResult<CartModel> cartsRes =
            await Domain().cart.addProductToCart(cartModel);
        if (cartsRes.isSuccess) {
          emit(state.copyWith(status: CartStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              status: CartStatus.failure, errMessage: cartsRes.error));
        }
      } else {
        XResult<CartModel> cartsRes =
            await Domain().cart.addProductToCart(cartModel);
        if (cartsRes.isSuccess) {
          emit(state.copyWith(status: CartStatus.success, errMessage: ""));
        } else {
          emit(state.copyWith(
              status: CartStatus.failure, errMessage: cartsRes.error));
        }
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

  void setPromoToCart(PromoModel promoModel) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      var total = _getTotalPrice(state.carts, promoModel.salePercent);
      emit(state.copyWith(
          status: CartStatus.success,
          salePercent: promoModel.salePercent,
          totalPrice: total,
          code: promoModel.id,
          errMessage: ""));
    } catch (_) {
      emit(state.copyWith(
          status: CartStatus.failure, errMessage: "Something wrong"));
    }
  }

  void clearCodePromo() async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      var total = _getTotalPrice(state.carts, 0);
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
          var total = _getTotalPrice(event.data!, state.salePercent);
          emit(state.copyWith(
              status: CartStatus.success,
              carts: event.data,
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

  void cartSearch(String searchInput) async {
    emit(state.copyWith(searchInput: searchInput));
  }

  void cartOpenSearchBarEvent() async {
    emit(state.copyWith(isSearch: !state.isSearch));
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

  void addFavoriteToCart(FavoriteProduct favoriteProduct) async {
    CartModel cartModel = CartModel(
        title: favoriteProduct.productItem.title.toLowerCase(),
        productItem: favoriteProduct.productItem,
        size: favoriteProduct.size,
        color: favoriteProduct.color ?? "Black",
        quantity: 1);

    addToCart(cartModel);
  }

  bool checkContainTitle(String title) {
    return state.carts
        .where((element) => element.productItem.title == title)
        .toList()
        .isNotEmpty;
  }

  int _getIndexContainList(CartModel item) {
    return state.carts.indexWhere((element) =>
        element.productItem.id == item.productItem.id &&
        element.size == item.size &&
        element.color == item.color);
  }

  double _getTotalPrice(List<CartModel> list, [int? salePercent]) {
    double total = 0;

    for (var item in list) {
      double price = ProductHelper.getPriceWithSaleItem(
          item.productItem, item.color, item.size);

      total += (item.quantity * price);
    }
    if (salePercent != null && salePercent > 0) {
      total = total - (total * salePercent / 100);
    }
    return total;
  }

  bool checkContainInFavorite(FavoriteProduct item) {
    return state.carts
        .where((element) =>
            element.productItem.id == item.productItem.id &&
            element.size == item.size)
        .toList()
        .isNotEmpty;
  }
}
