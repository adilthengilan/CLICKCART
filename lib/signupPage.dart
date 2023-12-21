import 'package:clickcart/functions/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, left: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                          child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 400,
              width: 350,
              child: LottieBuilder.asset(
                  'assets/animations/Animation - 1700111312990.json'),
            ),
            SizedBox(
              height: 40,
              width: 300,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: EmailController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2),
                    prefixIcon: Icon(Icons.account_circle_rounded),
                    hintText: 'Enter your email... ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: 300,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: PasswordController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2),
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: 'password ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: 300,
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: PhoneNumberController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2),
                    prefixIcon: Icon(Icons.call),
                    hintText: 'Phone Number ',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (EmailController.text.isEmpty ||
                    PasswordController.text.isEmpty ||
                    PhoneNumberController.text.isEmpty) {
                  const snackdemo = SnackBar(
                    content: Text('Please fill the field'),
                    backgroundColor: Color.fromARGB(255, 4, 4, 4),
                    elevation: 10,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                } else {
                  signUp(EmailController.text, PasswordController.text);

                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 40,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                Text('Already have an account  '),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'SignIn',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Provider.of<fetchDatas>(context, listen: false).saveUserData();
      SavePhoneNumber();
      // On successful signup, you can navigate to the next screen or perform other actions.
      print('User signed up: ${userCredential.user!.uid}');
    } catch (e) {
      // Handle errors here, such as invalid email format, weak password, etc.
      print('Failed to sign up: $e');
    }
  }

  Future<void> SavePhoneNumber() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to the collection 'users' in Firestore
        final users =
            FirebaseFirestore.instance.collection('users').doc(userId);
        // Replace 'userData' with the document name or ID
        // Here, a new document will be created with the user ID

        await users.set({
          'PhoneNumber': PhoneNumberController.text,
          // Add more fields as needed
        });

        print('Data saved successfully for user ID: $userId');
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}

class variables {}
