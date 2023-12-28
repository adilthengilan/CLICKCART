import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/ViewModel/cart.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/indexfinder.dart';
import 'package:clickcart/ViewModel/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class cart extends StatefulWidget {
  cart({
    super.key,
  });

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  void initState() {
    super.initState();
  }

  Collections collections = Collections();
  Reminder reminder = Reminder();
  IndexFinder indexFinder = IndexFinder();

  final BoldStyle = TextStyle(fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseProvider>(context, listen: false);
    final inCart = Provider.of<CartProvider>(context);
    // data.fetchDataFromFirestore();
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Total:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 6, left: 5),
                  child: Text(
                    '\$${inCart.totalamount}',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 199, 7, 7)),
                height: 40,
                width: 90,
                child: TextButton(
                    onPressed: () {
                      if (inCart.totalamount == 0) {
                        reminder.showToast('Please add Products to cart');
                      } else {
                        inCart.initiateRazorPay();
                        inCart.startPayment(inCart.totalamount);
                        addDateandTime(context);
                      }
                    },
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    )))
          ],
        ),
        color: Colors.white,
        height: 80,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              if (collections.BottomBarIndex == 1) {
                collections.BottomBarIndex = 0;
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width / 1.05,
                child: Cartss(),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width / 1.05,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        'Payment Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(width: 300, child: Divider()),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Text('Order Items '),
                              width: 260,
                            ),
                            Text(
                              ' Items',
                              style: BoldStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('MRP Total '),
                            SizedBox(
                              width: 200,
                            ),
                            Text(
                              '\$${inCart.totalamount}',
                              style: BoldStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Service & Shipping Fee '),
                            SizedBox(
                              width: 135,
                            ),
                            Text(
                              'Free',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.green),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
    );
  }

  void addDateandTime(BuildContext context) {
    final data = Provider.of<fetchDatas>(context, listen: false);
    DateTime now = DateTime.now();
    collections.TimeandDate = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
  }
}

class Cartss extends StatefulWidget {
  const Cartss({super.key});

  @override
  State<Cartss> createState() => _CartssState();
}

class _CartssState extends State<Cartss> {
  Collections collections = Collections();
  IndexFinder indexFinder = IndexFinder();
  Reminder reminder = Reminder();
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final data = Provider.of<CartProvider>(context, listen: false);

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            data.products = snapshot.data!.get('carts');
            data.totalamount = snapshot.data!.get('total');
            List<dynamic> productId = snapshot.data!.get('Productid');
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => DetailPage(),
                    //     ));
                  },
                  child: ListTile(
                    title: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 200),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: 200,
                                    child: Text(
                                      data.products[index]['Name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 300,
                              child: Text(
                                data.products[index]['Description'],
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 220,
                              child: Text(
                                '${data.products[index]['Discount']}% off',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green),
                              ),
                            ),
                            Stack(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // indexFinder.findProductIndex(collections
                                        //     .cartProduct[index]['Name']);
                                      },
                                      child: Container(
                                        child: Center(
                                          child: Text('-'),
                                        ),
                                        margin: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5),
                                        height: 20,
                                        width: 20,
                                        color: const Color.fromARGB(
                                            255, 221, 221, 221),
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                          child: Text(
                                        '1',
                                        style: TextStyle(fontSize: 11.5),
                                      )),
                                      height: 20,
                                      width: 15,
                                      color: Color.fromARGB(255, 244, 244, 244),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // data.findProductIndex(
                                        //     data.cartProduct[index]['Name']);
                                        // data.quantityindex = index;
                                      },
                                      child: Container(
                                        child: Center(child: Text('+')),
                                        height: 20,
                                        width: 20,
                                        color: const Color.fromARGB(
                                            255, 221, 221, 221),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                    subtitle: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 30),
                          child: SizedBox(
                            width: 300,
                            child: Stack(children: [
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Text(
                                  '\$${data.products[index]['Price']}',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 150, top: 10),
                                child: IconButton(
                                    onPressed: () {
                                      data.removeItemFromCart(
                                          data.products[index]['Name'],
                                          data.products[index]['Price'],
                                          data.products[index]['Image'],
                                          data.products[index]['Rating'],
                                          productId[index]['id'],
                                          data.products[index]['Description'],
                                          data.products[index]['Discount']);
                                    },
                                    icon: Image.asset(
                                        'assets/images/deleteIcon.png')),
                              )
                            ]),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Divider(
                            height: 50,
                            thickness: 2,
                          ),
                        )
                      ],
                    ),
                    leading: Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${data.products[index]['Image']}'),
                              fit: BoxFit.fill),
                          color: const Color.fromARGB(255, 203, 199, 199),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 100,
                      width: 80,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          }
        });
  }
}
// Stack(children: [
//             Container(
//               margin: EdgeInsets.only(
//                   top: MediaQuery.of(context).size.height / 1.41),
//               height: 80,
//               width: MediaQuery.of(context).size.width / 1.0,
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 242, 232, 232),
//                   borderRadius: BorderRadius.all(Radius.circular(30))),
              // child: Row(
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.only(left: 20),
              //       child: Text(
              //         'Total:',
              //         style:
              //             TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              //       ),
              //     ),
              //     SizedBox(
              //         height: 40,
              //         width: MediaQuery.of(context).size.width / 2,
              //         child: Padding(
              //           padding: EdgeInsets.only(top: 6, left: 5),
              //           child: Text(
              //             '\$${Provider.of<fetchDatas>(context).totalamount}',
              //             style: TextStyle(
              //                 fontSize: 27, fontWeight: FontWeight.w900),
              //           ),
              //         )),
              //     Container(
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.all(Radius.circular(20)),
              //             color: Color.fromARGB(255, 199, 7, 7)),
              //         height: 40,
              //         width: 90,
              //         child: TextButton(
              //             onPressed: () {
              //               if (data.totalamount == 0) {
              //                 data.showToast('Please add Products to cart');
              //               } else {
              //                 data.initiateRazorPay();
              //                 data.startPayment(data.totalamount);
              //                 addDateandTime(context);
              //               }
              //             },
              //             child: Text(
              //               'Order Now',
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w700),
              //             )))
              //   ],
              // ),
//             ),
//           ])