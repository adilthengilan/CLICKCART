import 'package:clickcart/Model/collections.dart';
import 'package:flutter/material.dart';

class IndexFinder  extends ChangeNotifier{
  int BottomBarIndex = 0;

  int currentindex = 0;
  
  // void findProductIndex(String productName) {
  //   try {
  //     final index =
  //         products.indexWhere((product) => product['title'] == productName);
  //     if (index == -1) {
  //       print('suscessfullyyyy $index');
  //     } else {
  //       collections.currentindex = index;
  //     }
  //   } catch (e) {}
  // }
}
