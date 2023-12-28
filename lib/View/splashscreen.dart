import 'dart:async';
import 'package:clickcart/View/dashboard.dart';
import 'package:clickcart/View/loginpage.dart';
import 'package:connectivity/connectivity.dart';

import 'package:clickcart/ViewModel/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      checkInternet();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<fetchDatas>(context).fetchData();

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

  Future<void> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TryAgain(),
          ));
    } else {
      checkLoggedInUser();
    }
  }
}

class TryAgain extends StatelessWidget {
  const TryAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: LottieBuilder.asset('assets/animations/No internet.json'),
          ),
        ),
        Text('No Internet Connection..?'),
        Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 75, 5, 160),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14))))),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                    ),
                    (route) => false);
              },
              child: Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    ));
  }
}
