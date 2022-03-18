class AuthCredentials {
  final String? name;
  final String email;
  final String? password;
  String? userId;

  AuthCredentials({
    this.name,
    required this.email,
    this.password,
    this.userId,
  });
}
