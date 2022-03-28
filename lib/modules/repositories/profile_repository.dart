import 'dart:convert';

import 'package:e_commerce_app/modules/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  Future<User> getProfile() async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = jsonDecode(pref.getString('userInfo')!);
    return User.fromJson(userMap);
  }
}
