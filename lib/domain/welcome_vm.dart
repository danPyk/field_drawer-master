import 'package:dartz/dartz.dart';
import 'package:field_drawer/app/injection.dart';
import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/back/signing/login/login_impl.dart';
import 'package:field_drawer/back/signing/registration/registration_impl.dart';
import 'package:field_drawer/domain/map_screen_vm.dart';
import 'package:field_drawer/domain/signing/auth_failure.dart';
import 'package:field_drawer/front/widgets/snackabr.dart';
import 'package:field_drawer/models/user_signing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';


class WelcomeVM extends ChangeNotifier {
  late AnimationController _animationController;
  late SpringSimulation simulation;

//for curved animation
  late Animation<double> animation;

  AnimationController get animationController => _animationController;
  late GoogleSignIn googleSignIn;

  final RegistrationImpl _registrationImpl;
  final LoginImpl loginImpl;

  WelcomeVM(this._registrationImpl, this.loginImpl);

  void initAnimationController(TickerProvider tickerProvider) {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      //usually ticker=_WelcomeScreenState, plus implement SingleTickerProviderStateMixin
      vsync: tickerProvider,
    );
  }

  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticIn,
  ));


  void initAnimation() {
    animation = CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    //init animation
    _animationController.forward();
  }

  openPageIfUserNotExist(BuildContext context) async {
    final result = await createUser();
    if (result.isRight()) {
      sL<NavigationService>().navigateTo(Routes.mapScreen);
    } else {
      return GlobalSnackBar.show(context, result.toString());
    }
  }

  Future<Either<dynamic, String?>> createUser() async {
    final newUser = await _registrationImpl.createUser(email: googleSignIn.currentUser!.email, password: googleSignIn.currentUser!.id);
    notifyListeners();

    return newUser;
  }

  // Future<void> checkIfUserExist() async{
  //   final prefix.User? user =  await getUser();
  //   var logger = Logger(); logger.d(user?.uid);
  // }

  Future<Either<dynamic, Unit>> logInUser() async {
    final result = await loginImpl.logInUser(email: googleSignIn.currentUser!.email, password: googleSignIn.currentUser!.id);
    if (result.isRight()) {
      notifyListeners();
      return result;
    } else {
      notifyListeners();
      return result;
    }
  }
}
