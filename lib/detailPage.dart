import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final data = Provider.of<fetchDatas>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 243, 239, 239),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Row(
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: 0, left: 40),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.all(Radius.circular(20))),
            //   height: 40,
            //   width: 120,
            //   child: Row(
            //     children: [
            //       InkWell(
            //         onTap: () {
            //           print('hellllllllo');
            //         },
            //         child: Container(
            //             margin: EdgeInsets.only(left: 10),
            //             child: Icon(Icons.shopping_cart)),
            //       ),
            //       Text(
            //         'Add to Cart',
            //         style: TextStyle(fontWeight: FontWeight.w600),
            //       )
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () {
                User? user = FirebaseAuth.instance.currentUser;

                Provider.of<fetchDatas>(context, listen: false)
                    .saveUserData(user!.uid);
              },
              child: Container(
                margin: EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 161, 156, 156),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 40,
                width: MediaQuery.of(context).size.width / 1.18,
                child: Center(
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 50),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 1.4, top: 50),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  height: 50,
                  width: 50,
                  child: SizedBox(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              data.products[data.currentindex]['thumbnail']),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: const Color.fromARGB(255, 199, 197, 197)),
                  margin: EdgeInsets.only(
                      top: 10, left: MediaQuery.of(context).size.width / 23),
                  height: 300,
                  width: MediaQuery.of(context).size.width / 1.1,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: const Color.fromARGB(255, 243, 239, 239)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data.products[data.currentindex]['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  Text(data.products[data.currentindex]['description']),
                  Text('${data.products[data.currentindex]['price']}')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
