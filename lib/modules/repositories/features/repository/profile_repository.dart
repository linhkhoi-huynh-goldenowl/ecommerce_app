import 'package:e_commerce_app/modules/models/e_user.dart';

import '../../x_result.dart';

abstract class ProfileRepository {
  Future<void> setCurrentUser(EUser user);
  Future<EUser> getProfile();
  Future<bool> saveProfile(EUser eUser);
  Future<XResult> changePassword(
      String email, String oldPass, String newPassword);
}
