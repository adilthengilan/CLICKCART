import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/reminder.dart';
import 'package:clickcart/ViewModel/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Likes extends StatefulWidget {
  const Likes({super.key});

  @override
  State<Likes> createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  Collections collections = Collections();

  @override
  Widget build(BuildContext context) {
    final firebase = Provider.of<FirebaseProvider>(context, listen: false);
    final InCart = Provider.of<CartProvider>(context, listen: false);
    final data = Provider.of<WishListProvider>(context);
    Reminder reminder = Reminder();
    final size = MediaQuery.of(context).size;
    // data.FromFirestore();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'WishList',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.149,
            width: double.infinity,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    data.WishlistProducts = snapshot.data!.get('wishlist');

                    return ListView.builder(
                      itemCount: data.WishlistProducts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromARGB(255, 255, 255, 255)),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 120,
                                      child: Text(
                                        data.WishlistProducts[index]['Name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 7,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        data.removeItemFromeWishlist(
                                            data.WishlistProducts[index]
                                                ['Name'],
                                            data.WishlistProducts[index]
                                                ['Price'],
                                            data.WishlistProducts[index]
                                                ['Image'],
                                            data.WishlistProducts[index]
                                                ['Rating'],
                                            data.WishlistProducts[index]['id'],
                                            data.WishlistProducts[index]
                                                ['Description'],
                                            data.WishlistProducts[index]
                                                ['Discount']);
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset(
                                            'assets/images/deleteIcon.png'),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: size.height / 20,
                                  child: Text(
                                    data.WishlistProducts[index]['Description'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width / 6,
                                      child: Text(
                                        '\$${data.WishlistProducts[index]['Price']}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 6,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bool IsInCart = firebase.cartProductId
                                            .contains(data
                                                .WishlistProducts[index]['id']);
                                        IsInCart
                                            ? reminder.showToast(
                                                'Product Already In Cart')
                                            : [
                                                InCart.saveItemtoCart(
                                                    data.WishlistProducts[index]
                                                        ['Name'],
                                                    data.WishlistProducts[index]
                                                        ['Price'],
                                                    data.WishlistProducts[index]
                                                        ['Image'],
                                                    data.WishlistProducts[index]
                                                        ['Rating'],
                                                    data.WishlistProducts[index]
                                                        ['id'],
                                                    data.WishlistProducts[index]
                                                        ['Description'],
                                                    data.WishlistProducts[index]
                                                        ['Discount'],
                                                    1),
                                                reminder.showToast(
                                                    'Product Added to Cart')
                                              ];
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Center(
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            Text(
                                              'Move to Cart',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            leading: Container(
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          '${data.WishlistProducts[index]['Image']}'),
                                      fit: BoxFit.fill),
                                  color:
                                      const Color.fromARGB(255, 203, 199, 199),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: 80,
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
          )
        ],
      ),
    );
  }
}
