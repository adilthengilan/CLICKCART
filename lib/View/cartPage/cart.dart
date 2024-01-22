import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/cartPage/cartProductListing.dart';
import 'package:clickcart/View/orderPage/orderPage.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/indexfinder.dart';
import 'package:clickcart/ViewModel/reminder.dart';
import 'package:flutter/material.dart';
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
    final indexes = Provider.of<IndexFinder>(context, listen: false);
    final inCart = Provider.of<CartProvider>(context);
    final data = Provider.of<FirebaseProvider>(context);
    inCart.getTotalAmount();
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
                    '\$${inCart.totalprices}',
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
                      if (inCart.totalprices == 0) {
                        reminder.showToast('Please add Products to cart');
                      } else {
                        // inCart.initiateRazorPay();
                        // inCart.startPayment(inCart.totalprices);
                        // addDateandTime(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPage(),
                            ));
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
        leading: (indexes.BottomBarIndex == 1)
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                              '\$${inCart.totalprices}',
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
    final dateandtime = Provider.of<CartProvider>(context, listen: false);
    DateTime now = DateTime.now();
    dateandtime.DateandTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
  }
}
