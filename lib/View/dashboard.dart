import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/home.dart';
import 'package:clickcart/View/notification.dart';
import 'package:clickcart/View/profile.dart';
import 'package:clickcart/ViewModel/functions.dart';

import 'package:clickcart/view/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navigators extends StatefulWidget {
  const Navigators({super.key});

  @override
  State<Navigators> createState() => _NavigatorsState();
}

class _NavigatorsState extends State<Navigators> {
  Collections collections = Collections();

  final List<Widget> _screens = [
    Dashboard(),
    cart(),
    Notifications(),
    Profile() // Add more screens as needed
  ];

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: collections.BottomBarIndex,
        onTap: (int index) {
          setState(() {
            collections.BottomBarIndex = index;
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
            icon: Stack(children: [
              Icon(Icons.notifications),
              Padding(
                padding: EdgeInsets.only(left: 18),
                child: Container(
                  child: Center(
                    child: Text(
                      '${collections.Notifications.length}',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              )
            ]),
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: _screens[collections.BottomBarIndex],
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

