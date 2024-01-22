import 'package:clickcart/View/orderPage/addressPage.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Container addressContainer(BuildContext context, final address) {
  final style = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  return Container(
    margin: EdgeInsets.only(left: 20, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deliver to: ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            width: double.infinity,
            child: (address.isEmpty)
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressPage(),
                            ));
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Center(
                          child: Text(
                            'Add Address',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address[0]['Address'],
                          style: style,
                        ),
                        Text(
                          address[0]['District'],
                          style: style,
                        ),
                        Text(
                          address[0]['State'],
                          style: style,
                        ),
                        Text(
                          address[0]['PhoneNumber'],
                          style: style,
                        )
                      ],
                    ),
                  )),
        SizedBox(
          height: 10,
        )
      ],
    ),
  );
}

Container products(BuildContext context) {
  final Products = Provider.of<CartProvider>(context).Cartproducts;
  return Container(
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: Products.length,
      itemBuilder: (context, index) {
        if (Products.isNotEmpty) {
          return ListTile(
            leading: Container(
              height: 100,
              width: 80,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${Products[index]['Image']}'),
                      fit: BoxFit.contain)),
            ),
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Products[index]['Name'],
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('${Products[index]['Description']}'),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        '${Products[index]['Rating']}',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${Products[index]['Discount']}% Discount Offer',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${Products[index]['Price']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(blurRadius: 2)],
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: 30,
                        width: 50,
                        child: Center(
                            child: Text(
                          'Qty: ${Products[index]['quantity']}',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    ),
  );
}

Container banner() {
  return Container(
    color: Color.fromARGB(255, 246, 246, 246),
    height: 100,
    width: double.infinity,
    child: Center(
      child: Row(
        children: [
          SizedBox(
            width: 60,
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/banner image.png'))),
          ),
          SizedBox(
              width: 210,
              child: Text(
                'Safe and secure payments.100% authentic Products.',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              )),
        ],
      ),
    ),
  );
}
