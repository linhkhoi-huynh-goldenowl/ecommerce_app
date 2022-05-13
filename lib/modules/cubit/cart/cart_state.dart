part of 'cart_cubit.dart';

enum CartStatus {
  initial,
  success,
  failure,
  loading,
}
enum AddCartStatus {
  initial,
  success,
  failure,
  loading,
}

class CartState extends Equatable {
  const CartState(
      {this.carts = const <CartModel>[],
      this.status = CartStatus.initial,
      this.totalPrice = 0,
      this.code = "",
      this.salePercent = 0,
      this.errMessage = "",
      this.searchInput = "",
      this.isSearch = false,
      this.addStatus = AddCartStatus.initial});
  final List<CartModel> carts;
  List<CartModel> get cartsListToShow {
    List<CartModel> cartsShow = carts;
    if (searchInput != "") {
      cartsShow = cartsShow
          .where((element) => element.title.contains(searchInput.toLowerCase()))
          .toList();
    }

    return cartsShow;
  }

  final CartStatus status;
  final AddCartStatus addStatus;
  final double totalPrice;
  final String code;
  final int salePercent;
  final String errMessage;
  final String searchInput;
  final bool isSearch;

  CartState copyWith(
      {CartStatus? status,
      List<CartModel>? carts,
      double? totalPrice,
      String? code,
      int? salePercent,
      String? errMessage,
      bool? isSearch,
      String? searchInput,
      bool? isShowCategoryBar,
      AddCartStatus? addStatus}) {
    return CartState(
        status: status ?? this.status,
        carts: carts ?? this.carts,
        totalPrice: totalPrice ?? this.totalPrice,
        code: code ?? this.code,
        salePercent: salePercent ?? this.salePercent,
        errMessage: errMessage ?? this.errMessage,
        searchInput: searchInput ?? this.searchInput,
        isSearch: isSearch ?? this.isSearch,
        addStatus: addStatus ?? this.addStatus);
  }

  @override
  List<Object> get props => [
        status,
        carts,
        totalPrice,
        code,
        salePercent,
        errMessage,
        searchInput,
        isSearch,
        addStatus
      ];
}
