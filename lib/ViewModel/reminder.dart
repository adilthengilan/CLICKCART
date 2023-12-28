import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Reminder {
  void showToast(String Message) {
    Fluttertoast.showToast(
      msg: Message,
      toastLength:
          Toast.LENGTH_SHORT, // Duration for which the toast is visible
      gravity: ToastGravity.BOTTOM, // Toast gravity (TOP, BOTTOM, CENTER)
      backgroundColor: Colors.grey[700], // Background color of the toast
      textColor: Colors.white, // Text color of the toast message
      fontSize: 16.0, // Font size of the toast message
    );
  }

}
