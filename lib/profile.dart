import 'package:clickcart/functions/provider.dart';
import 'package:clickcart/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
            onPressed: () {
              Provider.of<fetchDatas>(context, listen: false)
                  .signOutUser(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (route) => false);
            },
            child: Text('signout')),
      ),
    );
  }
}
