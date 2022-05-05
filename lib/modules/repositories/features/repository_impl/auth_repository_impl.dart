import 'package:e_commerce_shop_app/modules/models/e_user.dart';
import 'package:e_commerce_shop_app/modules/repositories/features/repository/auth_repository.dart';
import 'package:e_commerce_shop_app/modules/repositories/provider/user_provider.dart';
import 'package:e_commerce_shop_app/modules/repositories/x_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserProvider _userProvider = UserProvider();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _facebookAuth = FacebookAuth.instance;

  @override
  Future<XResult<EUser>> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final XResult<EUser> result =
          await _userProvider.getUser(userCredential.user!.uid);
      if (result.data != null) {
        _saveLocalStorage(result.data?.id ?? "", "email");
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
          shippingAddress: 0,
          orderCount: 0,
          reviewCount: 0,
          notificationSale: false,
          notificationNewArrivals: false,
          notificationDelivery: false);
      _userProvider.setUser(eUser);

      _saveLocalStorage(_uid!, "email");
      return XResult.success(eUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return XResult.error('Invalid-email.');
      } else if (e.code == 'email-already-in-use') {
        return XResult.error('Email was used');
      } else {
        return XResult.error("Something was not right");
      }
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

      return await getLoginFromSocial(result, userCredential, "google");
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

      return await getLoginFromSocial(result, userCredential, "facebook");
    } catch (_) {
      return XResult.error("Something was not right");
    }
  }

  Future<XResult<EUser>> getLoginFromSocial(XResult<EUser> result,
      UserCredential userCredential, String typeLogin) async {
    if (result.isSuccess) {
      _saveLocalStorage(result.data?.id ?? "", typeLogin);
      return result;
    } else {
      final eUser = EUser(
          id: userCredential.user!.uid,
          email: userCredential.user?.email ?? "",
          name: userCredential.user!.displayName ?? "",
          dateOfBirth: null,
          shippingAddress: 0,
          orderCount: 0,
          reviewCount: 0,
          notificationSale: false,
          notificationNewArrivals: false,
          notificationDelivery: false);
      _userProvider.setUser(eUser);
      _saveLocalStorage(userCredential.user!.uid, typeLogin);

      return XResult.success(eUser);
    }
  }

  Future<void> _saveLocalStorage(String uid, String typeLogin) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("userId", uid);
    pref.setBool("isLogin", true);
    pref.setString("loginType", typeLogin);
  }

  @override
  Future<XResult<String>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return XResult.success("Send complete");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return XResult.error('Email address is not valid.');
      } else if (e.code == 'user-not-found') {
        return XResult.error(
            'We couldn\'t find your email on the system, please enter the correct email');
      } else {
        return XResult.error('Something wrong');
      }
    }
  }
}
