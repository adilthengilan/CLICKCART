import 'package:clickcart/View/homePage/dashboard.dart';
import 'package:clickcart/View/registrationPage/loginpage.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Google Sign-In was canceled.");
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = authResult.user;

      // Navigate to the home page after successful sign-in
      createFieldinFirebase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigators()),
      );
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      googleSignIn.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
    notifyListeners();
  }

  //////////////////////////////////////////////////
  ///________THIS FUNCTION IS USED FOR SIGNOUT FROM THE APP.AND NAVIGATE
  ///TO THE LOGIN PAGE./////////////////////////////////
  void signOutUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false);
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
