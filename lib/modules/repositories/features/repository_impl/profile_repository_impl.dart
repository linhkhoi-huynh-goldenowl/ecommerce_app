import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_shop_app/modules/models/e_user.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/profile_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/user_provider.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final UserProvider _userProvider = UserProvider();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late EUser localUser;
  @override
  Future<EUser> getProfile() async {
    return localUser;
  }

  @override
  Future<bool> saveProfile(EUser eUser) async {
    try {
      _userProvider.setUser(eUser);

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setCurrentUser(EUser user) async {
    localUser = user;
  }

  @override
  Future<XResult> changePassword(
      String email, String oldPass, String newPassword) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      try {
        final cred =
            EmailAuthProvider.credential(email: email, password: oldPass);
        await currentUser!.reauthenticateWithCredential(cred);
      } on FirebaseAuthException {
        return XResult.error("Old Password Not Right");
      }

      await currentUser.updatePassword(newPassword);

      return XResult.success("Success");
    } catch (_) {
      return XResult.error("Something was not right");
    }
  }

  @override
  Stream<DocumentSnapshot<EUser>> getProfileStream(String id) {
    return _userProvider.snapshots(id);
  }
}
