import 'dart:convert';
import 'dart:ffi';
import 'package:clickcart/dashboard.dart';
import 'package:clickcart/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class fetchDatas with ChangeNotifier {
  var BottomBarIndex = 0;
  List<dynamic> products = [];

  List<dynamic> cartProduct = [];

  List<dynamic> cartProductid = [];

  late List<dynamic> filteredProducts = [];

  List<String> Notifications = [];

  List<dynamic> YourOrdersList = [];

  List<dynamic> Orders = [];

  List<dynamic> wishlistProduct = [];

  List<dynamic> WishlistIds = [];

  int currentindex = 0;

  int quantityindex = 0;

  var totalamount;
  String TimeandDate = '';

  String ApiKey = 'https://dummyjson.com/products';
  fetchDatas() {
    fetchData();
    notifyListeners();
  }
/////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///THIS FUNCTION IS USING TO FETCH DATAS FROM THE API.
  ///
  ///
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(ApiKey));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      products = jsonData['products'];
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
  ///_______THIS FUNCTION IS USED FOR SAVE THE PRODUCTS TO CART IN FIREBASE.
  ///______THE .SET FUNCTION IS FOR CREATE A FIELD IN FIREBASE AND .UPDATE IS USING FOR UPDATE
  ///THE LIST WHEN PRODUCTS WAS ADDED TO THE CART.
  ///

  Future<void> saveUserData() async {
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
            'Productid': [],

            // Add more fields as needed
          });
        } else {
          int totalprices =
              userssnap['total'] + products[currentindex]['price'];
          await users.update({
            'carts': FieldValue.arrayUnion([
              {
                'Name': products[currentindex]['title'],
                'Price': products[currentindex]['price'],
                'Image': products[currentindex]['thumbnail'],
                'Rating': products[currentindex]['rating'],
              }
            ]),
            'total': totalprices,
            'Productid': FieldValue.arrayUnion([products[currentindex]['id']]),

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

//////////////////////////////////////////////////
  ///________THIS FUNCTION IS USED FOR SIGNOUT FROM THE APP.AND NAVIGATE
  ///TO THE LOGIN PAGE./////////////////////////////////
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

  // Future<void> saveQuantity() async {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;

  //     User? user = auth.currentUser;
  //     if (user != null) {
  //       String userId = user.uid;

  //       // Reference to the collection 'users' in Firestore
  //       final users =
  //           FirebaseFirestore.instance.collection('users').doc(userId);
  //       final userssnap = await users.get();
  //       // Replace 'userData' with the document name or ID
  //       // Here, a new document will be created with the user ID
  //       if (!userssnap.exists) {
  //         await users.set({
  //           'quantity': [0]

  //           // Add more fields as needed
  //         });
  //       } else {
  //         int totalprices =
  //             userssnap['total'] + products[currentindex]['price'];
  //         int quantity = userssnap['quantity'][quantityindex] + 1;
  //         await users.update({
  //           'quantity': FieldValue.arrayUnion([quantity]),
  //           'total': totalprices,

  //           // Add more fields as needed
  //         });
  //       }
  //       notifyListeners();
  //       print('Data saved successfully for user ID: $userId');
  //     } else {
  //       print('User is not logged in.');
  //     }
  //   } catch (e) {
  //     print('Error saving data: $e');
  //   }
  // }

/////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
  ///THIS FUNCTION IS USED FOR SAVE THE WISHLIST PRODUCTS TO THE FIREBASE USING THE USER ID.
/////////////////////////////////////////////////////
  Future<void> SaveWishlist() async {
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
            'wishlist': [],
            'wishlistId': []
            // Add more fields as needed
          });
        } else {
          await users.update({
            'wishlist': FieldValue.arrayUnion([
              {
                'Name': products[currentindex]['title'],
                'Price': products[currentindex]['price'],
                'Image': products[currentindex]['thumbnail'],
              }
            ]),
            'wishlistIds': FieldValue.arrayUnion([products[currentindex]['id']])
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

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
  ///THIS FUNCTION IS USED FOR REMOVE THE PRODUCTS FROM CART USING THE PRODUCT INDEX FROM
  ///FIREBASE.
  ///
  Future<void> removeItemFromCart() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'carts': FieldValue.arrayRemove([
          {
            'Name': products[currentindex]['title'],
            'Price': products[currentindex]['price'],
            'Image': products[currentindex]['thumbnail'],
            'Rating': products[currentindex]['rating']
          }
        ]),
        'total': totalamount - products[currentindex]['price'],
        'Productid': FieldValue.arrayRemove([products[currentindex]['id']]),
      });
      notifyListeners();

      print('Item  removed from cart successfully$currentindex');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  // Future<void> decreasingquantity() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user!.uid)
  //         .update({
  //       'quantity': quantity - 1,
  //       'total': totalamount - products[currentindex]['price'],
  //     });
  //     notifyListeners();

  //     print('Item  removed from cart successfully$currentindex');
  //   } catch (e) {
  //     print('Error removing item from cart: $e');
  //   }
  // }

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
  ///THIS FUNCTION IS USED FOR REMOVE THE PRODUCTS FROM WISHLIST USING THE PRODUCT INDEX FROM
  ///FIREBASE.
  ///
  Future<void> removeItemFromeWishlist() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'wishlist': FieldValue.arrayRemove([
          {
            'Name': products[currentindex]['title'],
            'Price': products[currentindex]['price'],
            'Image': products[currentindex]['thumbnail'],
          }
        ]),
        'wishlistIds': FieldValue.arrayRemove([products[currentindex]['id']])
      });
      print('Item  removed from cart successfully$currentindex');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
    notifyListeners();
  }

//////////////////////////////////////////////////////////////////////////
  ///THIS FUNCTION IS USED FOR FILTER PRODUCTS FROM THE 'products' LIST WHEN SEARCHING
  ///BY USER .
  ///
  ///
  void filterProducts(String query) {
    filteredProducts = products.where((product) {
      // Customize the condition for filtering products based on your criteria
      return product['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

////////////////////////////////////////////////////////////
  ///
  ///THIS FUNCTION IS USED FOR FETCH DATA FROM FIREBASE TO TAKE VALUES TO THE
  ///APP , INCLUDES TOTAL PRICE , LISTS ETC....
  ///
  ///
  Future<void> fetchDataFromFirestore() async {
    FirebaseAuth fire = FirebaseAuth.instance;
    User? fires = fire.currentUser;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(fires!.uid)
          .get();

      totalamount = querySnapshot.get('total');
      cartProductid = querySnapshot.get('Productid');
      wishlistProduct = querySnapshot.get('wishlist');
      WishlistIds = querySnapshot.get('wishlistIds');
      YourOrdersList = querySnapshot.get('YourOrders');
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
  }

  Future<void> FromFirestore() async {
    FirebaseAuth fire = FirebaseAuth.instance;
    User? fires = fire.currentUser;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(fires!.uid)
          .get();

      wishlistProduct = querySnapshot.get('wishlist');
      WishlistIds = querySnapshot.get('wishlistIds');
      YourOrdersList = querySnapshot.get('YourOrders');
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> saveOrderDetails() async {
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
            'YourOrders': [],

            // Add more fields as needed
          });
        } else {
          await users.update({
            'YourOrders': FieldValue.arrayUnion([
              {'orders': cartProduct, 'Time': TimeandDate, 'total': totalamount}
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

  Future<void> saveOrderQuantity() async {
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
            'Quantity': [],

            // Add more fields as needed
          });
        } else {
          final List<int> quantitys = userssnap['Quantity'];
          final quantity = quantitys[currentindex] + 1;

          await users.update({
            'Quantity': FieldValue.arrayUnion([quantity]),

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

////////////////////////////////////////////////////////////////
  ///
  ///
  ///
  ///THIS FUNCTION IS USED FOR FIND THE INDEX OF PRODUCT FROM THE LIST 'products'
  ///THIS INDEX IS ASSIGNING THE CURRENT INDEX
  ///
  ///
  void findProductIndex(String productName) {
    try {
      final index =
          products.indexWhere((product) => product['title'] == productName);
      if (index == -1) {
        print('suscessfullyyyy $index');
      } else {
        currentindex = index;
      }
    } catch (e) {}
  }

  void addNotification(String message) {
    final data = message;
    Notifications.add(data);
  }

  ////////////////////////////////////////////////////////
  ///

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigators()),
      );
      saveUserData();
      addNotification('Successfully Logined ${user!.email}');
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

  void CleanCart() async {
    FirebaseAuth auth = FirebaseAuth.instance;
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

  final Razorpay _razorpay = Razorpay();

  initiateRazorPay() {
// To handle different event with previous functions
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    saveOrderDetails();
    addNotification(
        'Order Successfully Placed ${cartProduct.length} Products, Check Your Orders to know more...');
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

  void showToast(String Message) {
    Fluttertoast.showToast(
      msg: Message,
      toastLength:
          Toast.LENGTH_SHORT, // Duration for which the toast is visible
      gravity: ToastGravity.BOTTOM, // Toast gravity (TOP, BOTTOM, CENTER)
      backgroundColor: Colors.grey[700], // Background color of the toast
      textColor: Colors.white, // Text color of the toast message
      fontSize: 16.0, // Font size of the toast message
    );
  }
}

class Payment extends ChangeNotifier {}
