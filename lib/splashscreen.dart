import 'dart:async';

import 'package:clickcart/dashboard.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      checkLoggedInUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<fetchDatas>(context);
    return Scaffold(
      body: Center(
        child: Container(
          child: Image(image: AssetImage('assets/images/logo.png')),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void checkLoggedInUser() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is not logged in, navigate to the login screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      } else {
        // User is logged in, navigate to the home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Navigators(),
        ));
      }
    });
  }
}
