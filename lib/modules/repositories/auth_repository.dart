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
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? listEmail = prefs.getStringList('emails');
    List<String>? listPassword = prefs.getStringList('passwords');
    if (listEmail != null && listPassword != null) {
      if (listEmail.contains(email)) {
        if (listPassword[listEmail.indexOf(email)] == password) {
          prefs.setString("emailInfo", email);
          prefs.setBool("isLogin", true);
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
    final prefs = await SharedPreferences.getInstance();

    List<String>? listName = prefs.getStringList('names');
    List<String>? listPassword = prefs.getStringList('passwords');
    List<String>? listEmail = prefs.getStringList('emails');
    if (listName != null && listPassword != null && listEmail != null) {
      if (listEmail.contains(email)) {
        return false;
      } else {
        listName.add(name);
        listPassword.add(password);
        listEmail.add(email);
        prefs.setString("emailInfo", email);
        prefs.setBool("isLogin", true);
      }
    } else {
      listName = [name];
      listPassword = [password];
      listEmail = [email];
    }
    await prefs.setStringList('names', listName);
    await prefs.setStringList('passwords', listPassword);
    await prefs.setStringList('emails', listEmail);
    return true;
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
