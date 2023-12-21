import 'package:clickcart/cart.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/notification.dart';
import 'package:clickcart/home.dart';
import 'package:clickcart/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navigators extends StatefulWidget {
  const Navigators({super.key});

  @override
  State<Navigators> createState() => _NavigatorsState();
}

class _NavigatorsState extends State<Navigators> {
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
        currentIndex: data.BottomBarIndex,
        onTap: (int index) {
          setState(() {
            data.BottomBarIndex = index;
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
                      '${data.Notifications.length}',
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
      body: _screens[data.BottomBarIndex],
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

