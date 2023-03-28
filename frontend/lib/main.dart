import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'screens/hotels/sunny.dart';
import 'screens/user/auth/register/register.dart';
import 'screens/user/auth/login/login.dart';

import 'components/bottomNavs.dart';
import 'screens/mainPage/mainPage.dart';
// import 'favorites/favorites.dart';
import 'screens/user/booking/booking.dart';
import 'screens/user/user.dart';

import 'screens/admin/dashboard/dashboard.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/admin/hotelCrud/hotelDetails.dart';

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
        // 'favorite': (context) => Favorite(),
        'booking': (context) => Booking(),
        'user': (context) => User(),
        'sunny': (context) => Sunny(),
        'hotelCrud': (context) => HotelCrud(),
        'hotelDetails': (context) => HotelDetails(),
      },
    );
  }
}
