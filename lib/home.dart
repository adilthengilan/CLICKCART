import 'package:clickcart/detailPage.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/searchpage.dart';
import 'package:clickcart/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return SingleChildScrollView(
      child: Consumer<fetchDatas>(builder: (context, value, child) {
        // value.fetchDataFromFirestore();
        // value.FromFirestore();
        return SizedBox(
          height: 820,
          width: double.infinity,
          child: Column(
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.61,
                width: double.infinity,
                child: Categories(),
              )
            ],
          ),
        );
      }),
    );
  }

  final Message = FirebaseMessaging.instance;

  Future<void> initialNotification() async {
    await Message.requestPermission();
    final FCMTOken = await Message.getToken();
    print('FCM TOken : $FCMTOken');
    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  }

  Future<void> handleBackGroundMessage(RemoteMessage message) async {
    print('Title : ${message.notification?.title}');
    print('body : ${message.notification?.body}');
    print('data : ${message.data}');
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

List<QueryDocumentSnapshot> documents = [];
final CollectionReference Cart = FirebaseFirestore.instance.collection('Cart');
final CollectionReference Total =
    FirebaseFirestore.instance.collection('totalprice');
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

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

final class _CategoriesState extends State<Categories> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    data.fetchDataFromFirestore();
    return (data.products.isNotEmpty)
        ? GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 100 / 125,
                crossAxisCount: 2,
                mainAxisSpacing: 20),
            itemCount: data.products.length,
            itemBuilder: (context, index) {
              return Consumer<fetchDatas>(builder: (context, value, child) {
                return GridTile(
                    child: GestureDetector(
                  onTap: () {
                    // value.currentindex = index;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 237, 237),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.only(left: 15, right: 15),
                    // height: 200,
                    // width: 150,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(),
                            ));
                        value.currentindex = index;
                      },
                      child: Stack(children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 140,
                              width: 130,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          '${data.products[index]['thumbnail']}')),
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25, top: 5),
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: Text(
                                  data.products[index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '\$${data.products[index]['price']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(Icons.star),
                                ),
                                Text('${data.products[index]['rating']}')
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 165, left: 110),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: InkWell(
                            onTap: () {
                              // User? user = FirebaseAuth.instance.currentUser;
                              // addCartlist(index);
                              // addCart();
                              bool isinCart = data.cartProductid
                                  .contains(data.products[index]['id']);
                              isinCart
                                  ? value.showToast('Already in Cart')
                                  : [
                                      value.currentindex = index,
                                      value.saveUserData(),
                                      value.showToast('Product Added to Cart')
                                    ];
                            },
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ));
              });
            },
          )
        : Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
  }
}
