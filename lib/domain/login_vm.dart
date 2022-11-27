import 'package:dartz/dartz.dart';
import 'package:field_drawer/back/signing/login/login_impl.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';
import 'package:field_drawer/models/user_signing.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginVM extends ChangeNotifier {
  final LoginImpl loginImpl;
  final SharedPreferences prefs;

  LoginVM({required this.loginImpl, required this.prefs});

  late UserSigning userSigning;

  bool _checkBox = false;

  bool get checkBox => _checkBox;
  bool dataLoaded = false;

  set checkBox(bool checkBox) {
    _checkBox = checkBox;
    notifyListeners();
  }

  String getLogin() {
    String? result = prefs.getString('email');
    if (result == null) {
      return '';
    } else {
      return result;
    }
  }

  String getPassword() {
    String? result = prefs.getString('password');
    if (result == null) {
      return '';
    } else {
      return result;
    }
  }

  Future<void> savePreferences() async {
    if (checkBox == true) {
      await prefs.setString('email', userSigning.email);
      await prefs.setString('password', userSigning.password);
    }
  }

  Future<Either<dynamic, Unit>> logInUser() async {
    final result = await loginImpl.logInUser(email: userSigning.email, password: userSigning.password);
    if (result.isRight()) {
      notifyListeners();
      return result;
    } else {
      notifyListeners();
      return result;
    }
  }
}
