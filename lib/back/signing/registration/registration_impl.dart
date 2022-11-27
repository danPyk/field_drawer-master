import 'package:dartz/dartz.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';
import 'package:field_drawer/domain/signing/registration_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/injection.dart';


class RegistrationImpl extends RegistrationInterface {
  final FirebaseAuthInstaance? firebaseInjectableModule;

  RegistrationImpl(this.firebaseInjectableModule);

  @override
  Future<Either<AuthFailure, String?>> createUser({required String email, required String password}) async {
    if (password.length < 6) {
      return const Left(AuthFailure.Haslo_jest_za_krotkie());
    }
    try {
      final UserCredential? userCredential =
          await firebaseInjectableModule?.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return Right(userCredential?.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return left(const AuthFailure.Nieprawidlowy_email());
      } else if (e.code == 'wrong-password') {
        return left(const AuthFailure.Nieprawodlowe_haslo());
      } else {
        return left(const AuthFailure.Blad_serwera());
      }
    }
  }
}
