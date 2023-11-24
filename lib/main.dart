import 'package:clickcart/dashboard.dart';
import 'package:clickcart/detailPage.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => fetchDatas(),
        ),
        ChangeNotifierProvider(
          create: (context) => Payment(),
        ),
        ChangeNotifierProvider(
          create: (context) => Signup(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/SplashScreen': (context) => SplashScreen(),
          '/HomePage': (context) => Navigators(),
          '/DetailsPage': (context) => DetailPage()
        },
        title: 'ClickCart',
        home: SplashScreen(),
      ),
    );
  }
}
