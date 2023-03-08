import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'package:hotel_booking/auth/register/register.dart';
import 'package:hotel_booking/auth/login/login.dart';

import 'package:hotel_booking/bottomNavs.dart';
import 'package:hotel_booking/home/home.dart';
import 'favorites/favorites.dart';
import 'booking/booking.dart';
import 'package:hotel_booking/user/user.dart';

import 'package:hotel_booking/dashboard/dashboard.dart';
import 'package:hotel_booking/hotelCrud/hotelFirst.dart';
import 'package:hotel_booking/hotelCrud/hotelSecond.dart';
import 'hotelCrud/third.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  const Main({key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]); // To turn on full screen
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); // To disable full screen

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      home: MyRegister(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'dashboard': (context) => Dashboard(),
        'mainPage': (context) => BottomNavs(),
        'home': (context) => Home(),
        'user': (context) => User(),
        'booking': (context) => Booking(),
        'favorite': (context) => Favorite(),
        //
        'firstRoomCrud': (context) => First(),
        'secondRoomCrud': (context) => Second(),
        'thirdRoomCrud': (context) => third(),
      },
    );
  }
}
