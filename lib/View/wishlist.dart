import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/ViewModel/cart.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/indexfinder.dart';
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
  IndexFinder indexFinder = IndexFinder();
  Reminder reminder = Reminder();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseProvider>(context, listen: false);
    final InCart = Provider.of<CartProvider>(context, listen: false);
    // data.FromFirestore();
    data.fetchDataFromFirestore();

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
          Consumer<WishListProvider>(builder: (context, data, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.429,
              width: double.infinity,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> WishlistProducts =
                          snapshot.data!.get('wishlist');
                      return ListView.builder(
                        itemCount: WishlistProducts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 5),
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 255, 255, 255)),
                            child: ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Stack(children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 180),
                                    child: InkWell(
                                      onTap: () {
                                        data.removeItemFromeWishlist(
                                            WishlistProducts[index]['Name'],
                                            WishlistProducts[index]['Price'],
                                            WishlistProducts[index]
                                                ['thumbnail'],
                                            WishlistProducts[index]['Rating'],
                                            WishlistProducts[index]['id'],
                                            WishlistProducts[index]
                                                ['Description'],
                                            WishlistProducts[index]
                                                ['Discount']);
                                      },
                                      child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                              'assets/images/deleteIcon.png')),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 180,
                                    child: Text(
                                      WishlistProducts[index]['Name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ]),
                              ),
                              subtitle: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(
                                      '\$${WishlistProducts[index]['Price']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      indexFinder.findProductIndex(collections
                                          .wishlistProduct[index]['Name']);
                                      bool isinCart = collections.cartProductid
                                          .contains(collections.products[
                                              collections.currentindex]['id']);
                                      isinCart
                                          ? reminder.showToast(
                                              'Product already in Cart')
                                          : [
                                              indexFinder.findProductIndex(
                                                  collections.wishlistProduct[
                                                      index]['Name']),
                                              // InCart.saveItemtoCart(),
                                              reminder.showToast(
                                                  'Product added to Cart')
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
                              leading: Container(
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${collections.wishlistProduct[index]['Image']}'),
                                        fit: BoxFit.fill),
                                    color: const Color.fromARGB(
                                        255, 203, 199, 199),
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
            );
          }),
        ],
      ),
    );
  }
}
