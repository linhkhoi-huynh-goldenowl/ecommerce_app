import 'package:e_commerce_app/modules/models/e_user.dart';
import 'package:e_commerce_app/modules/repositories/features/repository/auth_repository.dart';
import 'package:e_commerce_app/modules/repositories/provider/user_provider.dart';
import 'package:e_commerce_app/modules/repositories/x_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserProvider _userProvider = UserProvider();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _facebookAuth = FacebookAuth.instance;

  @override
  Future<XResult<EUser>> login(String email, String password) async {
    try {
      final pref = await SharedPreferences.getInstance();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final XResult<EUser> result =
          await _userProvider.getUser(userCredential.user!.uid);
      if (result.data != null) {
        pref.setString("userId", result.data?.id ?? "");
        pref.setString("loginType", "email");
        pref.setBool("isLogin", true);
        return result;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return XResult.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return XResult.error('Wrong password provided for that user.');
      }
    }
    return XResult.error('Something was not right.');
  }

  @override
  Future<XResult<EUser>> signUp(
      String name, String email, String password) async {
    final pref = await SharedPreferences.getInstance();
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = _firebaseAuth.currentUser;
      final _uid = user?.uid;
      final eUser = EUser(
          id: _uid,
          email: email,
          name: name,
          dateOfBirth: null,
          shippingAddress: [],
          notificationSale: false,
          notificationNewArrivals: false,
          notificationDelivery: false);
      _userProvider.createUser(eUser);
      pref.setString("userId", _uid!);
      pref.setBool("isLogin", true);
      pref.setString("loginType", "email");
      return XResult.success(eUser);
    } catch (_) {
      return XResult.error("Something was not right");
    }
  }

  @override
  Future<void> signOut() async {
    final pref = await SharedPreferences.getInstance();
    final loginType = pref.getString("loginType");
    try {
      switch (loginType) {
        case "email":
          await _firebaseAuth.signOut();
          break;
        case "google":
          await _googleSignIn.disconnect();
          break;
        case "facebook":
          await _facebookAuth.logOut();
          break;
      }
      pref.setBool("isLogin", false);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<XResult<EUser>> checkAuthentication() async {
    final pref = await SharedPreferences.getInstance();
    final id = pref.getString("userId");
    if (pref.getBool("isLogin") == false || pref.getBool("isLogin") == null) {
      return XResult.error("error");
    } else {
      if (id == null) {
        return XResult.error("Don't find id");
      } else {
        final XResult<EUser> result = await _userProvider.getUser(id);
        return result;
      }
    }
  }

  @override
  Future<XResult<EUser>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final XResult<EUser> result =
          await _userProvider.getUser(userCredential.user!.uid);

      return await getLoginFromSocial(result, userCredential);
    } catch (_) {
      return XResult.error("Something was not right");
    }
  }

  @override
  Future<XResult<EUser>> loginWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      final facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      final XResult<EUser> result =
          await _userProvider.getUser(userCredential.user!.uid);

      return await getLoginFromSocial(result, userCredential);
    } catch (_) {
      return XResult.error("Something was not right");
    }
  }

  Future<XResult<EUser>> getLoginFromSocial(
      XResult<EUser> result, UserCredential userCredential) async {
    final pref = await SharedPreferences.getInstance();
    if (result.isSuccess) {
      pref.setString("userId", result.data?.id ?? "");
      pref.setBool("isLogin", true);
      pref.setString("loginType", "facebook");
      return result;
    } else {
      final eUser = EUser(
          id: userCredential.user!.uid,
          email: userCredential.user?.email ?? "",
          name: userCredential.user!.displayName ?? "",
          dateOfBirth: null,
          shippingAddress: [],
          notificationSale: false,
          notificationNewArrivals: false,
          notificationDelivery: false);
      _userProvider.createUser(eUser);
      pref.setString("userId", userCredential.user!.uid);
      pref.setBool("isLogin", true);
      pref.setString("loginType", "facebook");
      return XResult.success(eUser);
    }
  }
}
