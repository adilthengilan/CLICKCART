import 'package:clickcart/functions/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  void initState() {
    super.initState();
    Loaddata(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 300),
            child: TextButton(
                onPressed: () {
                  removedata();
                },
                child: Text(
                  'clear',
                  style: TextStyle(color: Colors.grey),
                )),
          ),
          SizedBox(
            child: NotifyList(),
            height: 600,
            width: 380,
          ),
        ],
      ),
    );
  }

  void Loaddata(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getStringList('Notification') ?? [];
  }

  void removedata() async {
    final data = Provider.of<fetchDatas>(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    setState(() {
      data.Notifications = [];
    });
  }
}

class NotifyList extends StatelessWidget {
  const NotifyList({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
    return ListView.builder(
      itemCount: data.Notifications.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          margin: EdgeInsets.only(left: 5, top: 5),
          height: 80,
          width: 390,
          child: ListTile(
            title: Text(
              data.Notifications[index],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            leading: Container(
                margin: EdgeInsets.only(top: 20),
                height: 50,
                width: 50,
                child: Icon(Icons.notifications_active)),
          ),
        );
      },
    );
  }

  void savedata(BuildContext context) async {
    final data = Provider.of<fetchDatas>(context);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('Notificaion', data.Notifications);
  }
}
