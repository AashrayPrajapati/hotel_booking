import 'package:flutter/material.dart';
import 'package:hotel_booking/login.dart';
import 'package:hotel_booking/register.dart';
import 'package:hotel_booking/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'home': (context) => Home()
    },
  ));
}
