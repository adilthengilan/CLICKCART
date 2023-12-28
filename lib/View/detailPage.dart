import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/Model/productDetails.dart';
import 'package:clickcart/ViewModel/cart.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/wishlist.dart';
import 'package:clickcart/view/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_swiper/card_swiper.dart';

class DetailPage extends StatefulWidget {
  String Name;
  int Price;
  double Rating;
  String Description;
  String Brand;
  String Category;
  double Discount;
  int Stock;
  List<String> Images;
  DetailPage(
      {super.key,
      required this.Name,
      required this.Price,
      required this.Rating,
      required this.Description,
      required this.Images,
      required this.Brand,
      required this.Category,
      required this.Discount,
      required this.Stock});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool onPressed = false;
  final controller = PageController();
  Products? obj;

  @override
  Widget build(BuildContext context) {
    print('==================================================${widget.Images}');
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    List<dynamic> images = [];
    Collections collections = Collections();
    // final data = Provider.of<FirebaseProvider>(context);
    // final wishlist = Provider.of<WishListProvider>(context);
    // final Incart = Provider.of<CartProvider>(context);
    // data.fetchDataFromFirestore();

    // bool isInWishlist = collections.WishlistIds.contains(
    //     collections.products[collections.currentindex]['id']);
    // bool isinCart = collections.cartProductid
    //     .contains(collections.products[collections.currentindex]['id']);
    images = widget.Images;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 30,
          height: 60,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.7,
              ),
              InkWell(
                onTap: () {
                  // isinCart
                  //     ? Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => cart(),
                  //         ))
                  //     : Incart.saveItemtoCart();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  height: 40,
                  width: 130,
                  // child: Center(
                  //   child: isinCart
                  //       ? Text(
                  //           'Go to Cart',
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w700,
                  //               fontSize: 18),
                  //         )
                  //       : Text(
                  //           'Add to Cart',
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w700,
                  //               fontSize: 18),
                  //         ),
                  // ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        // bottomNavigationBar: Container(
        //   height: 60,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //       color: Colors.transparent,
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        //   child: Row(
        //     children: [
        //       isinCart
        //           ? InkWell(
        //               onTap: () {
        //                 Navigator.push(context,
        //                     MaterialPageRoute(builder: (context) => cart()));
        //               },
        //               child: Container(
        //                 margin: EdgeInsets.only(left: 30),
        //                 decoration: BoxDecoration(
        //                     color: Colors.blue,
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(20))),
        //                 height: 40,
        //                 width: MediaQuery.of(context).size.width / 2.5,
        //                 child: Center(
        //                   child: Text(
        //                     'GO TO CART',
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.w700,
        //                         color: Colors.white),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           : InkWell(
        //               onTap: () {
        //                 data.saveUserData();
        //                 data.showToast('Product Added to Cart');
        //               },
        //               child: Container(
        //                 margin: EdgeInsets.only(left: 30),
        //                 decoration: BoxDecoration(
        //                     color: Colors.blue,
        //                     borderRadius:
        //                         BorderRadius.all(Radius.circular(20))),
        //                 height: 40,
        //                 width: MediaQuery.of(context).size.width / 2.5,
        //                 child: Center(
        //                   child: Text(
        //                     'ADD TO CART',
        //                     style: TextStyle(
        //                         fontWeight: FontWeight.w700,
        //                         color: Colors.white),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //       InkWell(
        //         onTap: () {
        //           data.startPayment(data.products[data.currentindex]['price']);
        //         },
        //         child: Container(
        //           margin: EdgeInsets.only(left: 10),
        //           decoration: BoxDecoration(
        //               color: Color.fromARGB(255, 244, 19, 19),
        //               borderRadius: BorderRadius.all(Radius.circular(20))),
        //           height: 40,
        //           width: MediaQuery.of(context).size.width / 2.5,
        //           child: Center(
        //             child: Text(
        //               'Buy Now',
        //               style: TextStyle(
        //                   fontWeight: FontWeight.w700, color: Colors.white),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.6,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Stack(children: [
                  PageView.builder(
                      controller: controller,
                      itemCount: images.length,
                      pageSnapping: true,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(images[index])),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: MediaQuery.of(context).size.height / 1.6,
                          margin: EdgeInsets.all(10),
                        );
                      }),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 45,
                            left: MediaQuery.of(context).size.width / 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 45,
                            left: MediaQuery.of(context).size.width / 1.4),
                        child: GestureDetector(
                          onTap: () {
                            // isInWishlist
                            //     ? wishlist.removeItemFromeWishlist()
                            //     : wishlist.SaveWishlist();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            // child: Center(
                            //   child: isInWishlist
                            //       ? Icon(
                            //           Icons.favorite,
                            //           color: Colors.red,
                            //         )
                            //       : Icon(
                            //           Icons.favorite_border,
                            //         ),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.8,
                        left: MediaQuery.of(context).size.width / 1.3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 123, 123, 123)),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 25,
                    width: 60,
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            '${widget.Rating}',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 20,
                      width: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 1.9),
                      child: Center(
                        child: SmoothPageIndicator(
                            controller: controller,
                            count: images.length,
                            effect: ScaleEffect()),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 190, 190, 190)),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.white),
                      height: 150,
                      width: 370,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.Name}',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            // Text(
                            //   '${collections.products[collections.currentindex]['discountPercentage']}% off',
                            //   style: TextStyle(
                            //       fontSize: 18,
                            //       color: Colors.green,
                            //       fontWeight: FontWeight.w600),
                            // ),
                            Text(
                              '\$${widget.Price}',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 233, 233, 233)),
                      height: 200,
                      width: 370,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About This Product',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Brand : ${widget.Brand}',
                              style: style,
                            ),
                            Text(
                              'Category : ${widget.Category}',
                              style: style,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description : ${widget.Description}}',
                              style: style,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Available : ${widget.Stock} Pieces only.!',
                              style: style,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final style = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
}
