import 'package:dartz/dartz.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';

abstract class RegistrationInterface {
  Future<Either<AuthFailure, String?>> createUser(
      {required String email, required String password});
}
