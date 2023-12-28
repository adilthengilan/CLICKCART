class Collections {
  String API_KEY = 'https://dummyjson.com/products';

  int BottomBarIndex = 0;

  int currentindex = 0;

  int quantityindex = 0;

  var totalamount;

  String TimeandDate = '';

  List<dynamic> products = [];

  List<dynamic> cartProduct = [];

  List<dynamic> cartProductid = [];

  late List<dynamic> filteredProducts = [];

  List<String> Notifications = [];

  List<dynamic> YourOrdersList = [];

  List<dynamic> Orders = [];

  List<dynamic> wishlistProduct = [];

  List<dynamic> WishlistIds = [];
}
