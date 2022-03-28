import 'dart:convert';

import 'package:e_commerce_app/modules/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<bool> checkAuthentication() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") == false || pref.getBool("isLogin") == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final pref = await SharedPreferences.getInstance();
    List<String>? listEmail = pref.getStringList('emails');
    List<String>? listUser = pref.getStringList('users');
    if (listEmail != null && listUser != null) {
      if (listEmail.contains(email)) {
        Map<String, dynamic> userMap =
            jsonDecode(listUser[listEmail.indexOf(email)]);
        User user = User.fromJson(userMap);
        if (user.password == password) {
          pref.setString("userInfo", json.encode(user.toJson()));
          pref.setBool("isLogin", true);
          return true;
        }
      }
    }

    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final pref = await SharedPreferences.getInstance();

    List<String>? listEmail = pref.getStringList('emails');
    List<String>? listUser = pref.getStringList('users');

    final User user = User(
        email: email,
        name: name,
        dateOfBirth: DateTime.now(),
        shippingAddress: [],
        password: password,
        notificationSale: false,
        notificationNewArrivals: false,
        notificationDelivery: false);
    String userInfo = json.encode(user.toJson());
    if (listUser != null && listEmail != null) {
      if (listEmail.contains(email)) {
        return false;
      } else {
        listEmail.add(email);
        pref.setBool("isLogin", true);

        listUser.add(userInfo);
      }
    } else {
      listEmail = [email];
      listUser = [userInfo];
    }
    await pref.setString('userInfo', userInfo);
    await pref.setStringList('users', listUser);
    await pref.setStringList('emails', listEmail);
    return true;
  }

  Future<void> signOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("userInfo");
    pref.setBool("isLogin", false);
  }
}

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  SubmissionFailed(this.exception);
}
