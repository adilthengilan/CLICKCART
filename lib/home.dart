import 'package:clickcart/detailPage.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    return SingleChildScrollView(
      child: Consumer<fetchDatas>(builder: (context, value, child) {
        return SizedBox(
          height: 820,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 15),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'))),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2.5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 234, 234, 234),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 15),
                child: Row(children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextField(
                      onChanged: (value) {
                        data.filterProducts(value);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                        hintText: "Search...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(166, 175, 16, 69),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Icon(Icons.tune, color: Colors.white),
                    ),
                  )
                ]),
              ),
              Container(
                margin: EdgeInsets.only(right: 260, top: 20),
                child: Text(
                  'Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.57,
                width: double.infinity,
                child: Categories(),
              )
            ],
          ),
        );
      }),
    );
  }
}

final CollectionReference Cart = FirebaseFirestore.instance.collection('Cart');
final CollectionReference Total =
    FirebaseFirestore.instance.collection('totalprice');
// void addCart() async {
//   await Cart.doc('cart').set({'products': cartProduct});
// }

// void AddtoCart(int index) {
//   final data = {
//     'Name': products[index]['title'],
//     'Price': products[index]['price'],
//     'Image': products[index]['thumbnail'],
//     'Rating': products[index]['rating']
//   };
//   Cart.add(data);
// }

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

final class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    data.filteredProducts = data.products;
    final products = Provider.of<fetchDatas>(context).products;
    return products.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 100 / 125,
                crossAxisCount: 2,
                mainAxisSpacing: 20),
            itemCount: data.filteredProducts.length,
            itemBuilder: (context, index) {
              return Consumer<fetchDatas>(builder: (context, value, child) {
                return GridTile(
                    child: GestureDetector(
                  onTap: () {
                    value.currentindex = index;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 237, 237),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.only(left: 15, right: 15),
                    // height: 200,
                    // width: 150,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(),
                            ));
                        value.currentindex = index;
                      },
                      child: Stack(children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 140,
                              width: 130,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          '${data.filteredProducts[index]['thumbnail']}')),
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25, top: 5),
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: Text(
                                  data.filteredProducts[index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '\$${data.filteredProducts[index]['price']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(Icons.star),
                                ),
                                Text(
                                    '${data.filteredProducts[index]['rating']}')
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 165, left: 110),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: InkWell(
                            onTap: () {
                              User? user = FirebaseAuth.instance.currentUser;
                              // addCartlist(index);
                              // addCart();
                              if (user != null) {
                                value.currentindex = index;
                                value.saveUserData(user.uid);
                              }
                            },
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ));
              });
            },
          )
        : Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
  }
}
