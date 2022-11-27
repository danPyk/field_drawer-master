import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../app/injection.dart';

class SignOut {
  FirebaseAuthInstaance? firebaseInjectableModule;
  SignOut({this.firebaseInjectableModule});

  Future<void> signOut()async {

    await firebaseInjectableModule?.firebaseAuth.signOut();
    //wait is used just to wait for multiple methods finish

  }
}
