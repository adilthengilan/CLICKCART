import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/Model/productDetails.dart';
import 'package:clickcart/View/detailPage.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/reminder.dart';
import 'package:clickcart/ViewModel/search_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

final class _CategoriesState extends State<Categories> {
  Products? obj;

  final FirebaseAuth auth = FirebaseAuth.instance;
  Collections collections = Collections();
  Reminder reminder = Reminder();
  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWith = MediaQuery.of(context).size.width;

    final data = Provider.of<FirebaseProvider>(context);

    final api = Provider.of<fetchDatas>(context);

    final cart = Provider.of<CartProvider>(context, listen: false);

    final filter = Provider.of<FilterProvider>(context);
    data.fetchDataFromFirestore();
    if (api.products.products.isNotEmpty) {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 100 / 125,
            crossAxisCount: 2,
            mainAxisSpacing: 20),
        itemCount: api.products.products.length,
        itemBuilder: (context, index) {
          //////////////////______The object products from the Api Provider is assigned to a variable is called 'products';
          final products = api.products.products;
          filter.allProducts = api.products.products;
          return Consumer<fetchDatas>(builder: (context, value, child) {
            return GridTile(
                child: GestureDetector(
              onTap: () {
                // value.currentindex = index;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(s
                //       builder: (context) => DetailPage(
                //           Name: snapshot.data!.products[index].title,
                //           Price: snapshot.data!.products[index].price,
                //           Rating: snapshot.data!.products[index].rating,
                //           Description:
                //               snapshot.data!.products[index].description,
                //           Images: [
                //             snapshot.data!.products[index].images[0]
                //           ]),
                //     ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 244, 244, 244),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: EdgeInsets.only(left: 15, right: 15),
                // height: 200,
                // width: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                              Name: products[index].title,
                              Price: products[index].price,
                              Rating: products[index].rating,
                              Description: products[index].description,
                              Images: products[index].images,
                              Brand: products[index].brand,
                              Category: products[index].category,
                              Discount: products[index].discountPercentage,
                              id: products[index].id,
                              Stock: products[index].stock,
                              thumbnail: products[index].thumbnail),
                        ));
                    // collections.currentindex = index;
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
                                      '${products[index].thumbnail}')),
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
                              '${products[index].title}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: ScreenWith / 15,
                                    top: ScreenHeight / 70),
                                child: Text(
                                  '\$${products[index].price}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: ScreenHeight / 70),
                              child: Icon(Icons.star),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ScreenHeight / 70),
                              child: Text('${products[index].rating}'),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenHeight / 4.8, left: ScreenWith / 3.5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: InkWell(
                        onTap: () {
                          bool isinCart =
                              data.cartProductId.contains(products[index].id);
                          isinCart
                              ? reminder.showToast('Product already inCart')
                              : [
                                  cart.saveItemtoCart(
                                      products[index].title,
                                      products[index].price,
                                      products[index].thumbnail,
                                      products[index].rating,
                                      products[index].id,
                                      products[index].description,
                                      products[index].discountPercentage,
                                      1),
                                  reminder.showToast('Product added to Cart')
                                ];
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
      );
      // : Center(
      //     child: SizedBox(
      //       height: 50,
      //       width: 50,
      //       child: CircularProgressIndicator(
      //         color: Colors.black,
      //       ),
      //     ),
      //   );
    } else {
      return Center(
          child: SizedBox(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
