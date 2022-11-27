import 'package:dartz/dartz.dart';
import 'package:field_drawer/back/signing/registration/registration_impl.dart';
import 'package:field_drawer/models/user_signing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'signing/auth_failure.dart';


class RegistrationVM extends ChangeNotifier {
   UserSigning userSigning = UserSigning('', '_password', false);
  final RegistrationImpl _registrationImpl;

  RegistrationVM(this._registrationImpl);

  Future<Either<dynamic, String?>> createUser() async {
    final newUser = await _registrationImpl.createUser(
        email: userSigning.email, password: userSigning.password);
    notifyListeners();

    return newUser;
  }
}
