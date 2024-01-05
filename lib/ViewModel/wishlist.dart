import 'package:clickcart/Model/collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishListProvider extends ChangeNotifier {
  Collections Keys = Collections();
  FirebaseAuth auth = FirebaseAuth.instance;

  List<dynamic> WishlistProducts = [];
  // Future<void> createWishListFields() async {
  //   if (auth.currentUser != null) {
  //     String userId = auth.currentUser!.uid;

  //     // Reference to the collection 'users' in Firestore
  //     final users = FirebaseFirestore.instance.collection('users').doc(userId);
  //     // final userssnap = await users.get();

  //     // if (!userssnap.exists) {

  //     // }
  //     notifyListeners();
  //   }
  // }

  Future<void> SaveWishlist(String Name, int Price, String thumbnail,
      double Rating, int id, String Description, double Discount) async {
    try {
      if (auth.currentUser != null) {
        String userId = auth.currentUser!.uid;

        // Reference to the collection 'users' in Firestore
        final users =
            FirebaseFirestore.instance.collection('users').doc(userId);
        final userssnap = await users.get();
        // Replace 'userData' with the document name or ID
        // Here, a new document will be created with the user ID
        if (!userssnap.exists) {
          await users.set({
            'wishlist': [], // Add more fields as needed
          });
        } else {
          await users.update({
            'wishlist': FieldValue.arrayUnion([
              {
                'Name': Name,
                'Price': Price,
                'Image': thumbnail,
                'Rating': Rating,
                'Description': Description,
                'Discount': Discount,
                'id': id
              }
            ]),
            'WishlistProductId': FieldValue.arrayUnion([id])
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

  Future<void> removeItemFromeWishlist(String Name, int Price, String thumbnail,
      double Rating, int id, String Description, double Discount) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'wishlist': FieldValue.arrayRemove([
          {
            'Name': Name,
            'Price': Price,
            'Image': thumbnail,
            'Rating': Rating,
            'Discount': Discount,
            'Description': Description,
            'id': id
          }
        ]),
        'WishlistProductId': FieldValue.arrayRemove([id])
      });
      print('Item  removed from cart successfully');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
    notifyListeners();
  }
}
