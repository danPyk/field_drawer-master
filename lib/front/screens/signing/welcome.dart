import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/domain/welcome_vm.dart';
import 'package:field_drawer/front/screens/signing/registration.dart';
import 'package:field_drawer/front/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../domain/signing/auth_failure.dart';
import 'package:dartz/dartz.dart' as prefix;

import 'login.dart';

//todo render overflow
//get rid of stateful
//todo add app name
class Welcome extends StatefulWidget {
  static String id = 'welcome_screen';

  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late WelcomeVM _welcomeVM;

  @override
  void initState() {
    _welcomeVM = Provider.of<WelcomeVM>(context, listen: false);
    _welcomeVM.initAnimationController(this);
    _welcomeVM.initAnimation();



    super.initState();
  }



  @override
  void dispose() {
    _welcomeVM.animationController.dispose();
    super.dispose();
  }

  void _pushPage(String pageName) {
    Navigator.pushNamed(context, pageName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              createAnimatedLogo(context),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),

              const SizedBox(
                height: 10.0,
              ),
              RoundedButton('Log in', () {
                _pushPage(LoginScreen.id);
              }, minWidth: MediaQuery.of(context).size.width * 0.4),
              const SizedBox(
                height: 10.0,
              ),
              RoundedButton('Register', () {
                _pushPage(RegistrationScreen.id);
              }, minWidth: MediaQuery.of(context).size.width * 0.4),
            ],
          ),
        ],
      ),
    );
  }

  Row createAnimatedLogo(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedBuilder(
          animation: _welcomeVM.animationController,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(115 * _welcomeVM.animationController.value, 0.0),
              child: ClipRect(
                child: Hero(
                  createRectTween: (begin, end) {
                    return MaterialRectCenterArcTween (begin: begin, end: end);
                  },
                  tag: 'logo',
                  child: Image.asset(
                    'assets/pictures/care2.png',
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
