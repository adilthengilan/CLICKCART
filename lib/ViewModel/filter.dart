import 'package:clickcart/Model/collections.dart';

class Filter {
  Collections collections = Collections();
  void filterProducts(String query) {
    collections.filteredProducts = collections.products.where((product) {
      // Customize the condition for filtering products based on your criteria
      return product['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
