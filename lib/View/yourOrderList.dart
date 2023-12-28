import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/Model/productDetails.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          'Your Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            child: Orderlist(),
            height: MediaQuery.of(context).size.height / 1.147,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

class Orderlist extends StatelessWidget {
  Orderlist({super.key});
  Collections collections = Collections();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> YourOrdersList = snapshot.data!.get('YourOrders');
            return ListView.builder(
              itemCount: YourOrdersList.length,
              itemBuilder: (context, index) {
                List<dynamic> Orders = YourOrdersList[index]['orders'];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    YourOrdersList[index]['Time'].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      Text('Status : '),
                                      Text(
                                        'Out For Delivery',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Text(
                                'Total Amount \$${YourOrdersList[index]['total']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              )),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: collections.Orders.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(Orders[index]['Name']),
                                subtitle: Text('\$${Orders[index]['Price']}'),
                                leading: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                '${Orders[index]['Image']}')))),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
