import 'package:clickcart/View/orderPage/widgets.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseProvider>(context).fetchDataFromFirestore();
    final address = Provider.of<FirebaseProvider>(context).address;

    final size = MediaQuery.of(context).size;
    final inCart = Provider.of<CartProvider>(context);
    ;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 150,
              child: Text(
                '\$${inCart.totalprices}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 80,
            ),
            GestureDetector(
              onTap: () {
                if (inCart.totalprices == 0) {
                  return;
                } else if (address.isEmpty) {
                  Reminder reminder = Reminder();
                  reminder.showToast('Please add Your address');
                } else {
                  inCart.initiateRazorPay();
                  inCart.startPayment(inCart.totalprices);
                  addDateandTime(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 35,
                width: 110,
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height / 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Divider(height: 10, thickness: 3),
            addressContainer(context, address),
            Divider(
              thickness: 10,
            ),
            SizedBox(width: double.infinity, child: products(context)),
            Divider(),
            banner()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  void addDateandTime(BuildContext context) {
    final dateandtime = Provider.of<CartProvider>(context, listen: false);
    DateTime now = DateTime.now();
    dateandtime.DateandTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
  }
}
