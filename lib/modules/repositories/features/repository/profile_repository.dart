import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/e_user.dart';

import '../../x_result.dart';

abstract class ProfileRepository {
  Future<void> setCurrentUser(EUser user);
  Future<EUser> getProfile();
  Future<XResult<EUser>> saveProfile(EUser eUser);
  Stream<DocumentSnapshot<EUser>> getProfileStream(String id);
  Future<XResult> changePassword(
      String email, String oldPass, String newPassword);
}
