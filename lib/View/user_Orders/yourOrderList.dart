import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/Model/constants/colors.dart';
import 'package:clickcart/Model/constants/styles.dart';
import 'package:clickcart/View/user_Orders/invoice.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
    final size = MediaQuery.of(context).size;
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
                return Column(children: [
                  Stack(children: [
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
                            itemCount: Orders.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(Orders[index]['Name']),
                                subtitle: Row(
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                            '\$${Orders[index]['Price']}')),
                                    SizedBox(
                                      width: size.width / 7,
                                    ),
                                    Container(
                                      height: 20,
                                      width: 100,
                                      child: Center(
                                        child: Text(
                                            'Qty : ${Orders[index]['quantity']}'),
                                      ),
                                    )
                                  ],
                                ),
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
                          InkWell(
                            onTap: () async {
                              // generate pdf file
                              final pdfFile = await PdfInvoiceApi.generate(
                                  YourOrdersList[index]['total'],
                                  Orders,
                                  context);

                              // opening the pdf file
                              FileHandleApi.openFile(pdfFile);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: size.width / 2, top: 20),
                              decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(blurRadius: 2)],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromARGB(255, 197, 197, 197)),
                              height: size.height / 25,
                              width: size.width / 2.5,
                              child: Center(
                                child:
                                    Text('Download Invoice', style: BoldText),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ]),
                ]);
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
