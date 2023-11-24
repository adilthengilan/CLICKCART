import 'package:clickcart/dashboard.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 300,
                width: 300,
                child: LottieBuilder.asset(
                    'assets/animations/Animation - 1700111312990.json'),
              ),
            ),
            Container(
              height: 40,
              width: 300,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 20),
                    hintText: 'email or username',
                    suffixIcon: Icon(Icons.account_box, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 40,
              width: 300,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    contentPadding: EdgeInsets.only(top: 10, left: 20),
                    hintText: 'password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))))),
                onPressed: () {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    const snackdemo = SnackBar(
                      content: Text('Please Check your Email and Password'),
                      backgroundColor: Color.fromARGB(255, 4, 4, 4),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  } else {
                    _signInWithEmailAndPassword();
                  }
                },
                child: Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 42, 41, 41)),
                    child: Center(
                        child: Text(
                      'SignIn',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                    )))),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 4, top: 10),
              child: Row(
                children: [
                  Text('Dont have an account?  '),
                  Text(
                    'Signup',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('or'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('___Signup with___',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<Signup>(context).signInWithGoogle(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3.1, top: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/123456.png')),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/download (1).png'),
                            fit: BoxFit.cover),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 20),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigators(),
          ));

      print('User signed in: ${userCredential.user!.uid}');
      // Navigate to the next screen or perform necessary actions upon successful login
    } catch (e) {
      print('Failed to sign in: $e');
      // Handle error: show a snackbar, dialog, or display an error message
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

void Signout() {
  _auth.signOut();
}
