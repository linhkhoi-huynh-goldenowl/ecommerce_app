abstract class AuthRepository {
  Future<bool> login(
    String email,
    String password,
  );

  Future<bool> signUp(
    String name,
    String email,
    String password,
  );

  Future<void> signOut();
}
