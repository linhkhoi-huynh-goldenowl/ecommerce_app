part of 'cart_cubit.dart';

enum CartStatus {
  initial,
  success,
  failure,
  loading,
}

class CartState extends Equatable {
  const CartState(
      {this.carts = const <CartModel>[], this.status = CartStatus.initial});
  final List<CartModel> carts;
  final CartStatus status;

  CartState copyWith({
    CartStatus? status,
    List<CartModel>? carts,
  }) {
    return CartState(status: status ?? this.status, carts: carts ?? this.carts);
  }

  @override
  List<Object> get props => [status, carts];
}
