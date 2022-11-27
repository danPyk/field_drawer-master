import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.Anulowano() = CancelledByUser;

  const factory AuthFailure.Blad_serwera() = ServerError;

  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;

  const factory AuthFailure.Nieprawidlowy_email() = InvalidEmail;
  const factory AuthFailure.Nieprawodlowe_haslo() = InvalidPassword;
  const factory AuthFailure.Konto_istnieje() = AccountAlreadyExist;
  const factory AuthFailure.Nieznaleziono_uzytkownika() = UserNotFound;
  const factory AuthFailure.Nieprawidlowy_emial_lub_haslo() = InvalidEmailAndPassword;
  const factory AuthFailure.Haslo_jest_za_krotkie() = PasswordToShort;
  const factory AuthFailure.Emial_ma_zly_format() = BadEmailFormat;
}
