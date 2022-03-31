import 'package:equatable/equatable.dart';

class SizeCloth extends Equatable {
  final String size;
  final double price;
  final int quantity;
  const SizeCloth(this.size, this.price, this.quantity);

  @override
  List<Object?> get props => [size, price, quantity];
}
