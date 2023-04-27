import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'screens/auth/register/register.dart';
import 'screens/auth/login/login.dart';

import 'mainPage.dart';
import 'screens/user/booking.dart';
import 'screens/super admin/registeredUsers.dart';
import 'screens/user/user.dart';

import 'screens/admin/hotelDashboard/dashboard.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/hotels/hotelInfo.dart';
import 'screens/hotels/roomType.dart';

import 'screens/super admin/registeredHotels.dart';
import 'screens/admin/roomCrud/createRoom.dart';

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
      theme: ThemeData(fontFamily: 'OpenSans'), // OPEN-SANS FONT STYLE
      home: MainPage(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        'hotelCrud': (context) => HotelCrud(),
        //
        'mainPage': (context) => MainPage(),
        'booking': (context) => Booking(),
        'user': (context) => User(),
        //
        'dashboard': (context) => Dashboard(),
        'hotelInfo': (context) => HotelInfo(),
        'roomCrud': (context) => RoomCrud(),
        'roomType': (context) => RoomType(),
        //
        'registeredUsers': (context) => RegisteredUsers(),
        'registeredHotels': (context) => RegisteredHotels(),
      },
    );
  }
}
