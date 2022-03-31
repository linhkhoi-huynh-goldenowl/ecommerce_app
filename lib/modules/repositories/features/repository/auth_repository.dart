import 'package:e_commerce_app/modules/models/e_user.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';

abstract class AuthRepository {
  Future<XResult<EUser>> checkAuthentication();
  Future<XResult<EUser>> login(
    String email,
    String password,
  );

  Future<XResult<EUser>> signUp(
    String name,
    String email,
    String password,
  );

  Future<void> signOut();
}
