part of 'cart_cubit.dart';

enum CartStatus {
  initial,
  success,
  failure,
  loading,
}

class CartState extends Equatable {
  const CartState(
      {this.carts = const <CartModel>[],
      this.status = CartStatus.initial,
      this.totalPrice = 0});
  final List<CartModel> carts;
  final CartStatus status;
  final double totalPrice;

  CartState copyWith(
      {CartStatus? status, List<CartModel>? carts, double? totalPrice}) {
    return CartState(
        status: status ?? this.status,
        carts: carts ?? this.carts,
        totalPrice: totalPrice ?? this.totalPrice);
  }

  @override
  List<Object> get props => [status, carts, totalPrice];
}
