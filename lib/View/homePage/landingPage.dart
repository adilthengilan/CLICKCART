import 'package:clickcart/View/homePage/productsListing.dart';
import 'package:clickcart/View/search_page/searchpage.dart';
import 'package:clickcart/View/wishlist.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/notification_service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Search = TextEditingController();

  void initState() {
    super.initState();
    initialNotification();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<fetchDatas>(context).fetchData();

    return SingleChildScrollView(
      child: Consumer<fetchDatas>(builder: (context, value, child) {
        // value.fetchDataFromFirestore();
        // value.FromFirestore();
        return SizedBox(
          height: 820,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 20),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'))),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Likes(),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 2.5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Icon(
                              Icons.favorite_outline,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: (auth.currentUser!.photoURL != null)
                                  ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          '${auth.currentUser!.photoURL}'))
                                  : DecorationImage(
                                      image: AssetImage(
                                          'assets/images/userprofile.png')),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 15),
                    child: Row(children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(),
                                ));
                          },
                          child: TextField(
                            decoration: InputDecoration(
                              enabled: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              hintText: "Search...",
                              filled: true,
                              fillColor: Color.fromARGB(255, 242, 240, 240),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(166, 16, 90, 175),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Icon(Icons.tune, color: Colors.white),
                        ),
                      )
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 240, top: 20),
                    child: Text(
                      'Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Categories(),
                  )
                ],
              ),
            ]),
          ),
        );
      }),
    );
  }

  final Message = FirebaseMessaging.instance;

  Future<void> initialNotification() async {
    await Message.requestPermission();
    NotificationServices().firebaseInit();
    final FCMTOken = await Message.getToken();
    print('FCM TOken : $FCMTOken');
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  }

  @pragma('Vm:entry-point')
  Future<void> handleBackGroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  void handleMessage(RemoteMessage? message) async {
    if (message != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Likes(),
          ));
    } else {
      return;
    }
  }
  // Future<void> configureFirebaseMessaging() async {
  //   final data = Provider.of<fetchDatas>(context, listen: false);

  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  //   // For handling foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("Received message: ${message.messageId}");
  //     data.addNotification('${message.messageId}');
  //     // Handle the foreground message here
  //   });

  //   // For handling when the app is in the background but opened by clicking on a notification
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("Opened message: ${message.messageId}");
  //     // Handle the message when the app is opened from the notification
  //   });

  //   // Request permission for iOS (if needed)
  //   NotificationSettings settings = await messaging.requestPermission();
  //   print("Notification settings: $settings");
  // }
}

// 
// void addCart() async {
//   await Cart.doc('cart').set({'products': cartProduct});
// }

// void AddtoCart(int index) {
//   final data = {
//     'Name': products[index]['title'],
//     'Price': products[index]['price'],
//     'Image': products[index]['thumbnail'],
//     'Rating': products[index]['rating']
//   };
//   Cart.add(data);
// }

