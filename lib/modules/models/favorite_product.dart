import 'package:e_commerce_app/modules/models/product_item.dart';
import 'package:equatable/equatable.dart';

class FavoriteProduct extends Equatable {
  final ProductItem productItem;
  final String size;
  const FavoriteProduct(
    this.productItem,
    this.size,
  );

  @override
  List<Object?> get props => [productItem, size];
}
