
import 'package:clickcart/View/splashscreen.dart';
import 'package:clickcart/ViewModel/cart_controller.dart';
import 'package:clickcart/ViewModel/fetchDataFromFirebase.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:clickcart/ViewModel/indexfinder.dart';
import 'package:clickcart/ViewModel/registration.dart';
import 'package:clickcart/ViewModel/search_controller.dart';
import 'package:clickcart/ViewModel/wishlist.dart';
import 'package:clickcart/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => fetchDatas(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => IndexFinder(),
        ),
        ChangeNotifierProvider(create: (context) => FilterProvider(),)
      ],
      child: MaterialApp(
      
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        // routes: {
        //   '/SplashScreen': (context) => SplashScreen(),
        //   '/HomePage': (context) => Navigators(),
        //   '/DetailsPage': (context) => DetailPage()
        // },
        title: 'ClickCart',
        home: SplashScreen(),
      ),
    );
  }
}
