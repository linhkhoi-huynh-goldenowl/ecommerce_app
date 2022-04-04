class SizeCloth {
  final String size;
  final double price;
  final int quantity;
  SizeCloth({required this.size, required this.price, required this.quantity});

  factory SizeCloth.fromJson(Map<String, dynamic> parsedJson) => SizeCloth(
        size: parsedJson['size'],
        price: parsedJson['price'].toDouble(),
        quantity: parsedJson['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'size': size,
        'price': price,
        'quantity': quantity,
      };
}
