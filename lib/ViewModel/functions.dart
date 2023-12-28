import 'dart:convert';

import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/Model/productDetails.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class fetchDatas with ChangeNotifier {
  Collections collections = Collections();

  fetchDatas() {
    fetchData();
    notifyListeners();
  }

  Future<Products> fetchData() async {
    // print("========================called==============================");

    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      notifyListeners();
      return Products.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

/////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///THIS FUNCTION IS USING TO FETCH DATAS FROM THE API.
  ///
  ///
}
