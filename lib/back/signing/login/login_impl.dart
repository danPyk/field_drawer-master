import 'package:dartz/dartz.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';
import 'package:field_drawer/domain/signing/login_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/injection.dart';

class LoginImpl implements LoginInterface {
  FirebaseAuthInstaance firebaseInjectableModule;

  LoginImpl(this.firebaseInjectableModule);

  @override
  Future<Either<AuthFailure, Unit>> logInUser({required String email, required String password}) async {
    try {
      await firebaseInjectableModule.firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return left(const AuthFailure.Nieprawidlowy_email());
      } else if (e.code == 'user-not-found') {
        return  left(const AuthFailure.Nieznaleziono_uzytkownika());
      } else if (e.code == 'wrong-password') {
        return left(const AuthFailure.Nieprawodlowe_haslo());
      } else {
        return left(const AuthFailure.Blad_serwera());
      }
    }
  }
}
