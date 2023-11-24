import 'package:clickcart/detailPage.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, left: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 78, 76, 76),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Icon(
                      Icons.arrow_left_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3.8),
                  child: Text(
                    'Your Cart',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 4),
                  child: Icon(Icons.shopping_cart),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.429,
            width: double.infinity,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> products = snapshot.data!.get('carts');
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => DetailPage(),
                            //     ));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            height: 90,
                            width: 280,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color.fromARGB(255, 223, 220, 220)),
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(products[index]['Name']),
                              ),
                              subtitle: Text(
                                '\$${products[index]['Price']}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                              leading: Container(
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${products[index]['Image']}'),
                                        fit: BoxFit.fill),
                                    color: const Color.fromARGB(
                                        255, 203, 199, 199),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 100,
                                width: 80,
                              ),
                              trailing: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.delete)),
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()));
                  }
                }),
          ),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 232, 232),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
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
                    child: Text('')),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 199, 7, 7)),
                    height: 40,
                    width: 90,
                    child: TextButton(
                        onPressed: () {
                          Provider.of<Payment>(context, listen: false)
                              .startPayment();
                        },
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }
}
