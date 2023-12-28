import 'package:clickcart/Model/collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider extends ChangeNotifier{

  Collections collections =  Collections();
   Future<void> fetchDataFromFirestore() async {
    FirebaseAuth fire = FirebaseAuth.instance;
    User? fires = fire.currentUser;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(fires!.uid)
          .get();

      collections.totalamount = querySnapshot.get('total');
      collections.cartProductid = querySnapshot.get('Productid');
      collections.wishlistProduct = querySnapshot.get('wishlist');
      collections.WishlistIds = querySnapshot.get('wishlistIds');
      collections.YourOrdersList = querySnapshot.get('YourOrders');
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
  }

}