import 'package:field_drawer/back/signing/login/login_impl.dart';
import 'package:field_drawer/back/signing/registration/registration_impl.dart';
import 'package:field_drawer/back/signing/sign_out.dart';
import 'package:field_drawer/domain/map_screen_vm.dart';
import 'package:field_drawer/back/permissions.dart';
import 'package:field_drawer/domain/welcome_screen_vm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stacked_services/stacked_services.dart';

final sL = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  ///singletons
  sL.registerLazySingleton(() => PermissionsService());
  sL.registerLazySingleton(() => NavigationService());
  sL.registerLazySingleton(() => SnackbarService());
  final internetChecker = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1), // Custom check timeout
    checkInterval: const Duration(seconds: 1), // Custom check interval
  );
  sL.registerLazySingleton<InternetConnectionChecker>(
    () => internetChecker,
  );

  ///factories
  sL.registerFactory(() => MapScreenVm());
  sL.registerFactory(() => WelcomeScreenVm(
      permissionsService: sL(),  snackbarService: sL()));




  ///login
  sL.registerSingleton(FirebaseAuthInstaance());
  sL.registerLazySingleton(() => LoginImpl(sL()));
  sL.registerLazySingleton(() => SignOut(firebaseInjectableModule: sL.get<FirebaseAuthInstaance>()));
  sL.registerLazySingleton(
          () => RegistrationImpl(sL.get<FirebaseAuthInstaance>()));

}
class FirebaseAuthInstaance {
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}

class SignOut {
  FirebaseAuthInstaance? firebaseInjectableModule;
  SignOut({this.firebaseInjectableModule});

  Future<void> signOut() {
    //wait is used just to wait for multiple methods finish
    return Future.wait([
      firebaseInjectableModule!.firebaseAuth.signOut(),
    ]);
  }
}
