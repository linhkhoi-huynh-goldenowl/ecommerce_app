import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modules/models/e_user.dart';
import 'package:e_commerce_app/modules/repositories/provider/base_collection.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';

class UserProvider extends BaseCollectionReference<EUser> {
  UserProvider()
      : super(FirebaseFirestore.instance
            .collection('users')
            .withConverter<EUser>(
                fromFirestore: (snapshot, options) =>
                    EUser.fromJson(snapshot.data() as Map<String, dynamic>),
                toFirestore: (user, _) => user.toJson()));

  Future<XResult<EUser>> setUser(EUser user) async {
    return await set(user);
  }

  Future<XResult<EUser>> getUser(String id) async {
    return await get(id);
  }
}
