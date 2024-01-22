import 'package:clickcart/Model/productDetails.dart';
import 'package:clickcart/View/cartPage/cart.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/wishlist.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  String Name;
  int Price;
  double Rating;
  String Description;
  String Brand;
  String Category;
  double Discount;
  int Stock;
  int id;
  String thumbnail;
  List<String> Images;
  DetailPage({
    super.key,
    required this.Name,
    required this.Price,
    required this.Rating,
    required this.Description,
    required this.Brand,
    required this.Category,
    required this.Discount,
    required this.Stock,
    required this.id,
    required this.thumbnail,
    required this.Images,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool onPressed = false;
  final controller = PageController();
  Products? obj;

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    List<dynamic> images = [];
    final data = Provider.of<FirebaseProvider>(context);
    final wishlist = Provider.of<WishListProvider>(context);
    final Incart = Provider.of<CartProvider>(context);
    data.fetchDataFromFirestore();

    bool isInWishlist = data.WishlistIds.contains(widget.id);
    bool isinCart = data.cartProductId.contains(widget.id);
    images = widget.Images;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(225, 237, 247, 255),
          elevation: 30,
          height: 60,
          child: Container(
            margin: EdgeInsets.all(5),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Price : \$${widget.Price}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  width: ScreenWidth / 4.5,
                ),
                InkWell(
                  onTap: () {
                    isinCart
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => cart(),
                            ))
                        : Incart.saveItemtoCart(
                            widget.Name,
                            widget.Price,
                            widget.thumbnail,
                            widget.Rating,
                            widget.id,
                            widget.Description,
                            widget.Discount,1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(117, 128, 198, 255),
                              spreadRadius: 1,
                              blurRadius: 10.0)
                        ],
                        color: Color.fromARGB(174, 240, 248, 255),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    height: 40,
                    width: 130,
                    child: Center(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.shopping_cart_sharp,
                          color: Color.fromARGB(255, 1, 113, 204),
                        ),
                        isinCart
                            ? Text(
                                'Go To Cart',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              )
                            : Text(
                                'Add To Cart',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
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
                        ),
                        height: MediaQuery.of(context).size.height / 2,
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
                          isInWishlist
                              ? wishlist.removeItemFromeWishlist(
                                  widget.Name,
                                  widget.Price,
                                  widget.thumbnail,
                                  widget.Rating,
                                  widget.id,
                                  widget.Description,
                                  widget.Discount)
                              : wishlist.SaveWishlist(
                                  widget.Name,
                                  widget.Price,
                                  widget.thumbnail,
                                  widget.Rating,
                                  widget.id,
                                  widget.Description,
                                  widget.Discount);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: isInWishlist
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: ScreenHeight / 2.07),
              height: ScreenHeight / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: ScreenWidth / 2.5,
                      ),
                      Center(
                        child: Container(
                          height: 20,
                          width: 65,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 0.5,
                                    blurRadius: 3,
                                    blurStyle: BlurStyle.outer)
                              ],
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Center(
                            child: SmoothPageIndicator(
                                controller: controller,
                                count: images.length,
                                effect: ScaleEffect()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenWidth / 4.5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0.5,
                                spreadRadius: 0.5,
                                blurStyle: BlurStyle.outer,
                                offset: Offset.zero,
                                color: Colors.black,
                              )
                            ],
                            border: Border.all(
                                color: Color.fromARGB(255, 255, 255, 255)),
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      '${widget.Name}',
                      style: heading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      '${widget.Brand} Product',
                      style: style,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: SizedBox(
                        width: ScreenWidth / 1.4,
                        child: Text(
                          '${widget.Description}',
                          style: description,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Category: ${widget.Category}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'Discount upto${widget.Discount}% off',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: StarRating(rating: widget.Rating),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating; // The value of the rating (double for more precision)
  final double starSize; // The size of each star
  final Color color; // The color of filled stars
  final Color borderColor; // The color of star borders

  const StarRating({
    Key? key,
    required this.rating,
    this.starSize = 30.0,
    this.color = Colors.yellowAccent,
    this.borderColor = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData = Icons.star;
        Color starColor = borderColor;

        if (index < rating) {
          iconData = Icons.star;
          starColor = color;
        } else if (index > rating - 1 && index < rating) {
          iconData = Icons.star_half;
          starColor = color;
        }

        return Icon(
          iconData,
          size: starSize,
          color: starColor,
        );
      }),
    );
  }
}

Container ListContainer(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
    height: 300,
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  );
}

final heading = TextStyle(fontSize: 27, fontWeight: FontWeight.w900);
final style = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
final description =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey);
