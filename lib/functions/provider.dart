import 'dart:convert';
import 'package:clickcart/dashboard.dart';
import 'package:clickcart/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class fetchDatas with ChangeNotifier {
  List<dynamic> products = [];
  List<dynamic> cartProduct = [];
  int currentindex = 0;
  int TotalPrice = 0;
  fetchDatas() {
    fetchData();
    notifyListeners();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      products = jsonData['products'];
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> saveUserData(String userId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to the collection 'users' in Firestore
        final users =
            FirebaseFirestore.instance.collection('users').doc(userId);
        final userssnap = await users.get();
        // Replace 'userData' with the document name or ID
        // Here, a new document will be created with the user ID
        if (!userssnap.exists) {
          await users.set({
            'carts': [],
            'total': 0,
            // Add more fields as needed
          });
        } else {
          await users.update({
            'carts': FieldValue.arrayUnion([
              {
                'Name': products[currentindex]['title'],
                'Price': products[currentindex]['price'],
                'Image': products[currentindex]['thumbnail'],
                'Rating': products[currentindex]['rating']
              }
            ]),
            'total': TotalPrice + products[currentindex]['price']
            // Add more fields as needed
          });
        }
        notifyListeners();

        print('Data saved successfully for user ID: $userId');
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  void signOutUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
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

  // Future<void> fetchTotalPrice() async {
  //   // Reference to the Firestore collection you want to fetch data from.
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('Login');

  //   try {
  //     // Query the collection to get a snapshot of the data.
  //     QuerySnapshot querySnapshot = await collectionReference.get();

  //     // Process the data in the snapshot.
  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //       // Access fields in the document.
  //       var data = documentSnapshot.data() as Map<String, dynamic>;
  //       var Total = data;
  //       TotalPrices = Total;
  //       // Do something with the data.
  //       // print('Field 1: $Username, Field 2: $Password');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }
  late List<dynamic> filteredProducts;

  void filterProducts(String query) {
    filteredProducts = products.where((product) {
      // Customize the condition for filtering products based on your criteria
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }
}

class Payment extends ChangeNotifier {
  final Razorpay _razorpay = Razorpay();

  initiateRazorPay() {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
// Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
// Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
// Do something when an external wallet is selected
  }

  void startPayment() {
    var options = {
      'key': 'rzp_test_8HwGoKx5qi6NaC', // Replace with your Razorpay API key
      'amount': 40000, // Amount in the smallest currency unit (e.g., cents)
      'name': 'Sample Store',
      'description': 'Test Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm'] // Additional wallets to support
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }
}
class Signup with ChangeNotifier{
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
      notifyListeners();

      // Navigate to the home page after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigators()),
      );
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  Future<void> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      googleSignIn.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}