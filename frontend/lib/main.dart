import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hotel_booking/khalti2.dart';
import 'package:hotel_booking/screens/hotels/getRoom.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
// import 'package:flutter/services.dart';

import 'khalti.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/auth/register/register.dart';
import 'screens/auth/login/login.dart';

import 'mainPage.dart';
import 'screens/hotels/updateHotel.dart';
import 'screens/hotels/updateRoom.dart';
import 'screens/hotels/viewBooking.dart';
import 'screens/super admin/registeredUsers.dart';
import 'screens/user/editUser.dart';
import 'screens/user/user.dart';

import 'booking.dart';
import 'screens/admin/hotelDashboard/dashboard.dart';
import 'screens/hotels/hotelInfo.dart';
import 'screens/hotels/roomType.dart';

import 'screens/super admin/registeredHotels.dart';
import 'screens/admin/roomCrud/createRoom.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(Main());
}

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
      // theme: ThemeData(fontFamily: 'OpenSans'), // OPEN-SANS FONT STYLE
      home: MyLogin(),
      routes: {
        'register': (context) => MyRegister(),
        'login': (context) => MyLogin(),
        //
        'mainPage': (context) => MainPage(),
        'user': (context) => User(),
        //
        'booking': (context) => BookingPage(),
        'dashboard': (context) => Dashboard(),
        'hotelCrud': (context) => HotelCrud(),
        'hotelInfo': (context) => HotelInfo(),
        'roomCrud': (context) => RoomCreate(),
        'roomType': (context) => RoomType(),
        //
        'registeredUsers': (context) => RegisteredUsers(),
        'registeredHotels': (context) => RegisteredHotels(),
        //
        'editUser': (context) => EditUser(),
        'updateHotel': (context) => UpdateHotel(),
        'khalti': (context) => Khalti(),
        'khalti2': (context) => Khalti2(),
        'updateRoom': (context) => UpdateRoom(),
        'getRooms': (context) => GetRooms(),
        'viewBooking': (context) => ViewBooking(),
      },
    );
  }
}
