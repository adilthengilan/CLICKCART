import 'package:clickcart/Model/collections.dart';

class IndexFinder {
  Collections collections = Collections();
  void findProductIndex(String productName) {
    try {
      final index =
          collections.products.indexWhere((product) => product['title'] == productName);
      if (index == -1) {
        print('suscessfullyyyy $index');
      } else {
        collections.currentindex = index;
      }
    } catch (e) {}
  }
}
