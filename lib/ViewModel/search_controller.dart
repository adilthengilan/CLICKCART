import 'package:clickcart/Model/productDetails.dart';
import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  List<dynamic> filteredProducts = [];
  List<Product> allProducts = [];

  void filterProducts(String query) {
    filteredProducts = allProducts.where((product) {
      // Customize the condition for filtering products based on your criteria
      return product.title.startsWith(query.toLowerCase());
    }).toList();
  }
}
