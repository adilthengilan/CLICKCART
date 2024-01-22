import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> quantityIncreasing(String Name, int Price, int quantity) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? user = auth.currentUser;

  // Replace 'userData' with the document name or ID
  // Here, a new document will be created with the user ID
  try {
    // Get reference to the document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    // Get the document snapshot
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Get the 'carts' array from the document
      List<dynamic> carts = docSnapshot['carts'];
      int totalPrice = docSnapshot['total'];

      // Find the product in the 'carts' array by its name
      Map<String, dynamic>? productToUpdate = carts.firstWhere(
        (cartItem) => cartItem['Name'] == Name,
        orElse: () => null,
      );
      int totalAmount = totalPrice + Price;
      if (productToUpdate != null) {
        // Update the quantity of the found product
        productToUpdate['quantity'] = quantity;

        // Update the 'carts' array in the document
        await docRef.update({'carts': carts, 'total': totalAmount});
        print('Quantity updated successfully!');
      } else {
        print('Product not found in the cart.');
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error updating quantity: $e');
  }
}

Future<void> quantityDecreasing(String Name, int Price, int quantity) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? user = auth.currentUser;

  // Replace 'userData' with the document name or ID
  // Here, a new document will be created with the user ID
  try {
    // Get reference to the document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    // Get the document snapshot
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Get the 'carts' array from the document
      List<dynamic> carts = docSnapshot['carts'];
      int totalPrice = docSnapshot['total'];

      // Find the product in the 'carts' array by its name
      Map<String, dynamic>? productToUpdate = carts.firstWhere(
        (cartItem) => cartItem['Name'] == Name,
        orElse: () => null,
      );
      int totalAmount = totalPrice - Price;
      if (productToUpdate != null) {
        // Update the quantity of the found product
        productToUpdate['quantity'] = quantity;

        // Update the 'carts' array in the document
        await docRef.update({'carts': carts, 'total': totalAmount});
        print('Quantity updated successfully!');
      } else {
        print('Product not found in the cart.');
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error updating quantity: $e');
  }
}
