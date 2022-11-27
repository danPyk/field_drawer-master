import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/back/signing/login/login_impl.dart';
import 'package:field_drawer/back/signing/registration/registration_impl.dart';
import 'package:field_drawer/domain/login_vm.dart';
import 'package:field_drawer/domain/registration_vm.dart';
import 'package:field_drawer/domain/welcome_vm.dart';
import 'package:field_drawer/firebase_options.dart';
import 'package:field_drawer/front/screens/signing/login.dart';
import 'package:field_drawer/front/screens/signing/registration.dart';
import 'package:field_drawer/front/screens/signing/welcome.dart';
import 'package:field_drawer/front/widgets/setup_widgets.dart';
import 'package:field_drawer/front/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stacked_services/stacked_services.dart';

import 'app/injection.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupErrorWidget();
  setupSnackbar();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => WelcomeVM(sL(), sL())),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                LoginVM(loginImpl: sL.get<LoginImpl>(), prefs: prefs)),
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                RegistrationVM(sL.get<RegistrationImpl>())),
      ],
      child: MaterialApp(
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          routes: {
            LoginScreen.id: (context) => const LoginScreen(),
            RegistrationScreen.id: (context) => const RegistrationScreen(),
            Welcome.id: (context) => const Welcome(),
            // SettingsScreen.id: (context) => SettingsScreen(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Welcome()),
    );
  }
}
