import 'package:field_drawer/app/injection.dart';
import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/domain/login_vm.dart';
import 'package:field_drawer/front/widgets/rounded_button_widget.dart';
import 'package:field_drawer/front/widgets/snackabr.dart';
import 'package:field_drawer/models/user_signing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';


//todo convert to stateless
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginVM _loginVM;

  @override
  void didChangeDependencies() {
    _loginVM = Provider.of<LoginVM>(context);

    if (_loginVM.dataLoaded == false) {
      _loginVM.userSigning = UserSigning(_loginVM.getLogin(), _loginVM.getPassword(), false);
      _loginVM.dataLoaded = true;
    }

    super.didChangeDependencies();
  }

  Future<void> _signInUser(BuildContext context) async {
    final result = await _loginVM.logInUser();
    if (result.isRight()) {
      sL<NavigationService>().navigateTo(Routes.mapScreen);
    } else {
      return GlobalSnackBar.show(context, result.toString().substring(17, result.toString().length -3  ));
    }
  }

//todo
  Widget spinKitOrContainer() {
    if (_loginVM.userSigning.isLoading == true) {
      return const SpinKitFadingCircle(color: Colors.lightBlue, size: 50.0);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    Hero(
                      createRectTween: (begin, end) {
                        return MaterialRectArcTween(begin: begin, end:end );
                      },
                      tag: 'logo',
                      child: Image.asset(
                        'assets/pictures/care2.png',
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                    const Text(
                      '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    TextFormField(
                      initialValue: _loginVM.userSigning.email,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _loginVM.userSigning.email = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      initialValue: _loginVM.userSigning.password,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        _loginVM.userSigning.password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s\b|\b\s'))],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RoundedButton(
                        'Log in',
                        () async {
                          await _signInUser(context);
                          await _loginVM.savePreferences();
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
                    spinKitOrContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
