import 'package:field_drawer/app/injection.dart';
import 'package:field_drawer/app/routes.router.dart';
import 'package:field_drawer/domain/registration_vm.dart';
import 'package:field_drawer/front/widgets/rounded_button_widget.dart';
import 'package:field_drawer/front/widgets/snackabr.dart';
import 'package:field_drawer/utils/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

//todo add height from mediaquery
class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationVM _registrationVM;

  @override
  void initState() {
    _registrationVM = Provider.of<RegistrationVM>(context, listen: false);

    super.initState();
  }

  _openPageIfUserExist(BuildContext context) async {
    final result = await _registrationVM.createUser();
    if (result.isRight()) {
     sL<NavigationService>().navigateTo(Routes.mapScreen);
    } else {
      return GlobalSnackBar.show(context, result.toString().substring(17, result.toString().length -3  ));
    }
  }

  Widget spinKitOrContainer() {
    if (_registrationVM.userSigning.isLoading == true) {
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

        body: ListView(shrinkWrap: true, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                Hero(
                  createRectTween: (begin, end) {
                    return CircularTween(begin: begin, end: end);
                  },
                  tag: 'logo',
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                        'assets/pictures/care2.png',
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _registrationVM.userSigning.email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  //ignore whitespaces
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s\b|\b\s'))],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _registrationVM.userSigning.password = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RoundedButton(
                    'Register',
                        () async {
                      await _openPageIfUserExist(context);
                    },
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
                spinKitOrContainer(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
