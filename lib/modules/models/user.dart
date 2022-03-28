class User {
  final String email;
  final String name;
  final DateTime dateOfBirth;
  final List<String> shippingAddress;
  final String password;
  final bool notificationSale;
  final bool notificationNewArrivals;
  final bool notificationDelivery;
  User({
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.shippingAddress,
    required this.password,
    required this.notificationSale,
    required this.notificationNewArrivals,
    required this.notificationDelivery,
  });

  User.fromJson(Map<String, dynamic> parsedJson)
      : email = parsedJson['email'],
        name = parsedJson['name'],
        dateOfBirth = DateTime.parse(parsedJson['dateOfBirth']),
        shippingAddress = parsedJson['shippingAddress'].cast<String>(),
        password = parsedJson['password'],
        notificationDelivery = parsedJson['notificationDelivery'],
        notificationNewArrivals = parsedJson['notificationNewArrivals'],
        notificationSale = parsedJson['notificationSale'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'shippingAddress': shippingAddress,
        'password': password,
        'notificationSale': notificationSale,
        'notificationNewArrivals': notificationNewArrivals,
        'notificationDelivery': notificationDelivery,
      };
}
