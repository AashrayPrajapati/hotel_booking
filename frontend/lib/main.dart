import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'screens/hotels/hotelInfo.dart';
import 'screens/user/auth/register/register.dart';
import 'screens/user/auth/login/login.dart';

import 'components/bottomNavs.dart';
import 'screens/mainPage/mainPage.dart';
import 'screens/user/booking/booking.dart';
import 'screens/user/favorites/favorites.dart';
import 'screens/user/user.dart';

import 'screens/admin/dashboard/dashboard.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/admin/hotelCrud/hotelDetails.dart';

import 'screens/admin/hotelCrud/adminDashboard.dart';
import 'screens/admin/roomCrud/roomCrud.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  const Main({key}) : super(key: key);
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      // home: BottomNavs(),
      home: BottomNavs(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'mainPage': (context) => BottomNavs(),
        'dashboard': (context) => Dashboard(),
        'home': (context) => Home(),
        'favorite': (context) => Favorite(),
        'hotelInfo': (context) => HotelInfo(),
        'hotelCrud': (context) => HotelCrud(),
        'hotelDetails': (context) => HotelDetails(),
        'adminDashboard': (context) => AdminDashboard(),
        'roomCrud': (context) => RoomCrud(),
        'booking': (context) => Booking(),
        'user': (context) => User(),
      },
    );
  }
}
