import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressPage extends StatelessWidget {
  AddressPage({super.key});

  final TextEditingController Address = TextEditingController();
  final TextEditingController District = TextEditingController();
  final TextEditingController State = TextEditingController();
  final TextEditingController PhoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          'Add address here',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Address'),
              controller: Address,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'District'),
              controller: District,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'State'),
              controller: State,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Phone Number'),
              controller: PhoneNumber,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                if (Address.text.isEmpty ||
                    District.text.isEmpty ||
                    State.text.isEmpty ||
                    PhoneNumber.text.isEmpty) {
                  return;
                } else {
                  AddAddress(context, Address.text, District.text, State.text,
                      PhoneNumber.text);
                }
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text(
                    'Add Address',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> AddAddress(BuildContext context, String Address, String District,
    String State, String Number) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  if (auth.currentUser != null) {
    String userId = auth.currentUser!.uid;
    final users = FirebaseFirestore.instance.collection('users').doc(userId);

    final userssnap = await users.get();

    if (userssnap.exists) {
      await users.update({
        'Address': FieldValue.arrayUnion([
          {
            'Address': Address,
            'District': District,
            'State': State,
            'PhoneNumber': Number
          }
        ]),

        // Add more fields as needed
      });
      Navigator.pop(context);
    }
  }
}
