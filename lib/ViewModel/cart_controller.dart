import 'package:clickcart/View/user_Orders/inAppNotification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartProvider extends ChangeNotifier {
  int totalprices = 0;
  String DateandTime = '';
  List<dynamic> Cartproducts = [];

  final Razorpay _razorpay = Razorpay();

  FirebaseAuth auth = FirebaseAuth.instance;

  ////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
  ///_______THIS FUNCTION IS USED FOR SAVE THE PRODUCTS TO CART IN FIREBASE.
  ///______THE .SET FUNCTION IS FOR CREATE A FIELD IN FIREBASE AND .UPDATE IS USING FOR UPDATE
  ///THE LIST WHEN PRODUCTS WAS ADDED TO THE CART.
  ///

  // Future<void> createFieldinCart() async {
  //   if (auth.currentUser != null) {
  //     String userId = auth.currentUser!.uid;
  //     // Reference to the collection 'users' in Firestore
  //     final users = FirebaseFirestore.instance.collection('users').doc(userId);
  //     // final userssnap = await users.get();
  //     // Replace 'userData' with the document name or ID
  //     // Here, a new document will be created with the user ID

  //     // if (!userssnap.exists) {}
  //     notifyListeners();
  //   }
  // }
  Future<void> getTotalAmount() async {
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);

    final total = await user.get();
    totalprices = total['total'];
    notifyListeners();
  }

  Future<void> saveItemtoCart(
      String Name,
      int Price,
      String thumbnail,
      double Rating,
      int id,
      String Description,
      double Discount,
      int quantity) async {
    try {
      if (auth.currentUser != null) {
        String userId = auth.currentUser!.uid;

        // Reference to the collection 'users' in Firestore
        final users =
            FirebaseFirestore.instance.collection('users').doc(userId);

        final userssnap = await users.get();
        // Replace 'userData' with the document name or ID
        // Here, a new document will be created with the user ID

        if (userssnap.exists) {
          int totalamount = userssnap['total'] + Price;
          await users.update({
            'carts': FieldValue.arrayUnion([
              {
                'Name': Name,
                'Price': Price,
                'Image': thumbnail,
                'Rating': Rating,
                'Description': Description,
                'Discount': Discount,
                'quantity': quantity
              }
            ]),
            'total': totalamount,
            'Productid': FieldValue.arrayUnion([id]),

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

  Future<void> removeItemFromCart(
      String Name,
      int Price,
      String thumbnail,
      double Rating,
      int id,
      String Description,
      double Discount,
      int quantity) async {
    User? user = auth.currentUser;

    final users = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final userssnap = await users.get();
    int totalamount = userssnap['total'] - Price;
    try {
      if (userssnap.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'carts': FieldValue.arrayRemove([
            {
              'Name': Name,
              'Price': Price,
              'Image': thumbnail,
              'Rating': Rating,
              'Description': Description,
              'Discount': Discount,
              'quantity': quantity
            }
          ]),
          'total': totalamount,
          'Productid': FieldValue.arrayRemove([id]),
        });
      }
      notifyListeners();

      // print('Item  removed from cart successfully$currentindex');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  // Future<void> removeIteFromCart(String Name, int Price, String thumbnail,
  //     double Rating, int id, String Description, double Discount, ) async {
  //   User? user = auth.currentUser;

  //   final users = FirebaseFirestore.instance.collection('users').doc(user!.uid);
  //   final userssnap = await users.get();
  //   int totalamount = userssnap['total'] - Price;
  //   try {
  //     if (userssnap.exists) {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .update({
  //         'carts': FieldValue.arrayUnion([
  //           {
  //             'Name': Name,
  //             'Price': Price,
  //             'Image': thumbnail,
  //             'Rating': Rating,
  //             'Description': Description,
  //             'Discount': Discount,
  //             'quantity': quantity
  //           }
  //         ]),
  //         'total': totalamount,
  //         'Productid': FieldValue.arrayRemove([id]),
  //       });
  //     }
  //     notifyListeners();

  //     // print('Item  removed from cart successfully$currentindex');
  //   } catch (e) {
  //     print('Error removing item from cart: $e');
  //   }
  // }

  Future<void> saveOrderDetails(
      String Time, int Total, List<dynamic> Orders) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Reference to the collection 'users' in Firestore
        final users =
            FirebaseFirestore.instance.collection('users').doc(userId);
        final userssnap = await users.get();
        // Replace 'userData' with the document name or ID
        // Here, a new document will be created with the user ID
        if (userssnap.exists) {
          await users.update({
            'YourOrders': FieldValue.arrayUnion([
              {'orders': Orders, 'Time': Time, 'total': Total}
            ]),

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

  void CleanCart() async {
    User? user = auth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'carts': [], 'total': 0, 'Productid': []});
    } catch (e) {
      print('Error removing item from cart: $e');
    }
    notifyListeners();
  }

  initiateRazorPay() {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    saveOrderDetails(DateandTime, totalprices, Cartproducts);
    CleanCart();

// Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
// Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
// Do something when an external wallet is selected
  }

  void startPayment(int amount) {
    var options = {
      'key': 'rzp_test_8HwGoKx5qi6NaC', // Replace with your Razorpay API key
      'amount':
          '${amount}00', // Amount in the smallest currency unit (e.g., cents)
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

///////////////////////////////////____this function is placed as globally for reusable the
/// code to create field in firebase-----------
Future<void> createFieldinFirebase() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  if (auth.currentUser != null) {
    String userId = auth.currentUser!.uid;
    final users = FirebaseFirestore.instance.collection('users').doc(userId);

    final userssnap = await users.get();

    if (!userssnap.exists) {
      await users.set({
        'carts': [],
        'total': 0,
        'Productid': [],
        'wishlist': [],
        'yourOrders': [],
        'Address': []

        // Add more fields as needed
      });
    }
  }
}
