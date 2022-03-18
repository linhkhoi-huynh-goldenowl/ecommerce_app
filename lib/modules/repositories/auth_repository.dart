import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<bool> attemptAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLogin") == false || prefs.getBool("isLogin") == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? listUsername = prefs.getStringList('usernames');
    List<String>? listPassword = prefs.getStringList('passwords');
    if (listUsername != null && listPassword != null) {
      if (listUsername.contains(username)) {
        if (listPassword[listUsername.indexOf(username)] == password) {
          prefs.setString("usernameInfo", username);
          prefs.setBool("isLogin", true);
          return true;
        }
      }
    }

    return false;
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? listUsername = prefs.getStringList('usernames');
    List<String>? listPassword = prefs.getStringList('passwords');
    List<String>? listEmail = prefs.getStringList('emails');
    if (listUsername != null && listPassword != null && listEmail != null) {
      if (listUsername.contains(username)) {
        return false;
      } else {
        listUsername.add(username);
        listPassword.add(password);
        listEmail.add(email);
        prefs.setString("usernameInfo", username);
        prefs.setBool("isLogin", true);
      }
    } else {
      listUsername = [username];
      listPassword = [password];
      listEmail = [email];
    }
    await prefs.setStringList('usernames', listUsername);
    await prefs.setStringList('passwords', listPassword);
    await prefs.setStringList('emails', listEmail);
    return true;
  }

  Future<String> confirmSignUp({
    required String username,
    required String confirmationCode,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'abc';
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", false);
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
