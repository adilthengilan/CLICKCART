import 'dart:convert';

import 'package:clickcart/Model/productDetails.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class fetchDatas with ChangeNotifier {
  fetchDatas() {
    fetchData();
    notifyListeners();
  }
  late Products products = Products(products: [], total: 0, skip: 0, limit: 0);

/////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///THIS FUNCTION IS USING TO FETCH DATAS FROM THE API.
  ///
  ///
  Future<Products> fetchData() async {
    // print("========================called==============================");

    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return products = Products.fromJson(responseData);
    } else {
      throw Exception('Failed to load products');
    }
  }

  List<Product> filteredProducts = [];

  filtering(String word) {
    filteredProducts = products.products
        .where((element) => element.title.toLowerCase().startsWith(word))
        .toList();
  }
}
