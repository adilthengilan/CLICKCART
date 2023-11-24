import 'package:clickcart/cart.dart';
import 'package:clickcart/favorites.dart';
import 'package:clickcart/home.dart';
import 'package:clickcart/profile.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navigators extends StatefulWidget {
  const Navigators({super.key});

  @override
  State<Navigators> createState() => _NavigatorsState();
}

class _NavigatorsState extends State<Navigators> {
  var _currentIndex = 0;
  final List<Widget> _screens = [
    Dashboard(),
    cart(),
    Likes(),
    Profile() // Add more screens as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.notifications),
            title: Text("Notifications"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 249, 244, 244),
      body: _screens[_currentIndex],
    );
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






// class Product {
//   final String productName;

//   Product({required this.productName});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productName: json["title"] as String, // Replace 'name' with your JSON key
//     );
//   }
// }

