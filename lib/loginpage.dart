import 'package:clickcart/dashboard.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/signupPage.dart';
import 'package:clickcart/splashscreen.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool obsecureText = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: 350,
                width: 350,
                child: LottieBuilder.asset(
                    'assets/animations/Animation - 1700111312990.json'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Screenheight / 100),
              height: 40,
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 20),
                    hintText: 'email or username',
                    prefixIcon:
                        Icon(Icons.account_circle_rounded, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 40,
              width: 300,
              child: TextField(
                obscureText: obsecureText,
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecureText = !obsecureText;
                          });
                        },
                        icon: Icon(obsecureText
                            ? Icons.visibility_off
                            : Icons.visibility)),
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
                  check();
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
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
                GestureDetector(
                  onTap: () {
                    final data =
                        Provider.of<fetchDatas>(context, listen: false);

                    data.signInWithGoogle(context);
                    if (auth.currentUser != null) {
                      data.SaveWishlist();
                      data.saveOrderDetails();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3.1, top: 20),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/google.png')),
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
                            image: AssetImage('assets/images/facebook.png'),
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
                      image: DecorationImage(
                          image: AssetImage('assets/images/download (5).png')),
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

  void check() {
    final data = Provider.of<fetchDatas>(context, listen: false);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      const snackdemo = SnackBar(
        content: Text('Please Check your Email and Password'),
        backgroundColor: Color.fromARGB(255, 4, 4, 4),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    } else {
      print('suuuuuuuuuuuiiiiiiiiiiiii');

      signInWithEmailAndPassword();
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        data.saveUserData();
      }
    }
  }

  void signInWithEmailAndPassword() async {
    final data = Provider.of<fetchDatas>(context, listen: false);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigators(),
          ));
      data.addNotification('${emailController.text} Successfully Logined');
      print('User signed in: ${userCredential.user!.uid}');
      // Navigate to the next screen or perform necessary actions upon successful login
    } catch (e) {
      const snack = SnackBar(
        content: Text('Please Check your Email and Password and Try Again'),
        backgroundColor: Color.fromARGB(255, 4, 4, 4),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
      print('Failed to sign in: $e');
      // Handle error: show a snackbar, dialog, or display an error message
    }
  }
}
