import 'package:dartz/dartz.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';

abstract class LoginInterface {
  Future<Either<AuthFailure, Unit>> logInUser(
      {required String email, required String password});
}
