import 'package:clickcart/View/loginpage.dart';
import 'package:clickcart/View/splashscreen.dart';
import 'package:clickcart/View/wishlist.dart';
import 'package:clickcart/View/yourOrderList.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/registration.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/images (2).png'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80, left: 20),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            image: (auth.currentUser!.photoURL != null)
                                ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        '${auth.currentUser!.photoURL}'))
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/userprofile.png')),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 80, left: 20),
                        child: (auth.currentUser!.displayName != null)
                            ? Text(
                                '${auth.currentUser!.displayName}',
                                style: textStyle,
                              )
                            : Text(
                                'User',
                                style: textStyle,
                              ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
            Container(
              margin: EdgeInsets.only(right: 200),
              height: 40,
              child: Text('YOUR ACCOUNT'),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/images/cartIcon.png'),
                    SizedBox(
                      width: 30,
                    ),
                    Text('My Orders'),
                    SizedBox(
                      width: ScreenWidth / 2,
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/images/Refer Icon.png'),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Refer & Earn'),
                    SizedBox(
                      width: ScreenWidth / 2.1,
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Divider(),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Likes(),
                    ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset('assets/images/wishlistIcon.png')),
                    SizedBox(
                      width: 35,
                    ),
                    Text('My WishList'),
                    SizedBox(
                      width: ScreenWidth / 2.1,
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(right: 180),
              child: Center(child: Text('HELP & SETTINGS')),
              height: 50,
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset('assets/images/CallSupport.png')),
                    SizedBox(
                      width: 35,
                    ),
                    Text('Need Help'),
                    SizedBox(
                      width: ScreenWidth / 2,
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Divider(),

            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/images/LocationIcon.png'),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Shipping Address'),
                    SizedBox(
                      width: ScreenWidth / 2.6,
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            Divider(),

            SizedBox(
              height: 70,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset('assets/images/logo.png'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  SizedBox(
                      width: 70,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('Are you sure want to Logout'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Provider.of<RegistrationProvider>(context,
                                                  listen: false)
                                              .signOutUser(context);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ),
                                              (route) => false);
                                        },
                                        child: Text('Yes')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'))
                                  ],
                                );
                              },
                            );
                          },
                          icon: Text('Signout')))
                ],
              ),
            )

            // Container(
            //   child: TextButton(
            //       onPressed: () {

            //       },
            //       child: Text('signout')),
            // ),
          ],
        ),
      ),
    );
  }

  void SignOut() async {
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        auth.signOut();
      });
    }
  }

  final textStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);
}
// InkWell(
//   onTap: () {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OrderPage(),
//         ));
//   },
//   child: Container(
//     margin: EdgeInsets.only(top: 10),
//     height: 40,
//     width: MediaQuery.of(context).size.width / 1.3,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: const Color.fromARGB(255, 234, 234, 234)),
//     child: Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10),
//           child: Icon(Icons.shopping_basket),
//         ),
//         Text(
//           '               MyOrders',
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: () {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Text(
//               '"if (the app is broken){ Just refresh and reuse} else{ use and enjoy}"'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('Okey'))
//           ],
//         );
//       },
//     );
//   },
//   child: Container(
//     margin: EdgeInsets.only(top: 10),
//     height: 40,
//     width: MediaQuery.of(context).size.width / 1.3,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: const Color.fromARGB(255, 234, 234, 234)),
//     child: Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10),
//           child: Icon(Icons.privacy_tip),
//         ),
//         Text(
//           '                 Privacy',
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: () {},
//   child: Container(
//     margin: EdgeInsets.only(top: 10),
//     height: 40,
//     width: MediaQuery.of(context).size.width / 1.3,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: const Color.fromARGB(255, 234, 234, 234)),
//     child: Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10),
//           child: Icon(Icons.help),
//         ),
//         Text(
//           '           Help & Support',
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: () {},
//   child: Container(
//     margin: EdgeInsets.only(top: 10),
//     height: 40,
//     width: MediaQuery.of(context).size.width / 1.3,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: const Color.fromARGB(255, 234, 234, 234)),
//     child: Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 10),
//           child: Icon(Icons.settings),
//         ),
//         Text(
//           '                 Settings',
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: () {
//     SignOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LoginPage(),
//         ),
//         (route) => false);
//   },
//   child: InkWell(
//     onTap: () {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Are you sure want to Logout'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Provider.of<fetchDatas>(context,
//                             listen: false)
//                         .signOutUser(context);
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoginPage(),
//                         ),
//                         (route) => false);
//                   },
//                   child: Text('Yes')),
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('No'))
//             ],
//           );
//         },
//       );
//     },
//     child: Container(
//       margin: EdgeInsets.only(top: 10),
//       height: 40,
//       width: MediaQuery.of(context).size.width / 1.3,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           color: const Color.fromARGB(255, 234, 234, 234)),
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: Icon(Icons.logout_outlined),
//           ),
//           Text(
//             '                 Logout',
//             style: TextStyle(fontSize: 20),
//           ),
//         ],
//       ),
//     ),
//   ),
// )
