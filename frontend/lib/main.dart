import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';

import 'auth/register/register.dart';
import 'auth/login/login.dart';

import 'bottomNavs.dart';
import 'home/home.dart';
import 'favorites/favorites.dart';
import 'booking/booking.dart';
import 'user/user.dart';

import 'dashboard/dashboard.dart';
// import 'package:hotel_booking/hotelCrud/hotelFirst.dart';
// import 'package:hotel_booking/hotelCrud/hotelSecond.dart';
// import 'hotelCrud/third.dart';
import 'hotelCrud/hotelCrud.dart';
import 'hotelCrud/hotelDetails.dart';

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
        'favorite': (context) => Favorite(),
        'booking': (context) => Booking(),
        'user': (context) => User(),
        //
        // 'firstRoomCrud': (context) => First(),
        // 'secondRoomCrud': (context) => Second(),
        // 'thirdRoomCrud': (context) => third(),
        'hotelCrud': (context) => HotelCrud(),
        'hotelDetails': (context) => HotelDetails(),
      },
    );
  }
}
