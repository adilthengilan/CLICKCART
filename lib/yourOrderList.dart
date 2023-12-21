import 'package:clickcart/functions/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget { 
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    data.FromFirestore();
    data.fetchDataFromFirestore();
    return Scaffold(
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
            height: MediaQuery.of(context).size.height / 1.124,
            width: double.infinity,
          )
        ],
      ),
    );
  }
}

class Orderlist extends StatelessWidget {
  const Orderlist({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);

    return ListView.builder(
      itemCount: data.YourOrdersList.length,
      itemBuilder: (context, index) {
        data.Orders = data.YourOrdersList[index]['orders'];
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
                            data.YourOrdersList[index]['Time'].toString(),
                            style: TextStyle(fontWeight: FontWeight.w700),
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
                        'Total Amount \$${data.YourOrdersList[index]['total']}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      )),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.Orders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data.Orders[index]['Name']),
                        subtitle: Text('\$${data.Orders[index]['Price']}'),
                        leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${data.Orders[index]['Image']}')))),
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
  }
}
