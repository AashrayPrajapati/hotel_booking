import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hotel_booking/screens/hotels/getRoom.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
// import 'package:flutter/services.dart';

import 'package:hotel_booking/getImage.dart';

import 'khalti.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/auth/changePassword.dart';
import 'screens/auth/forgotPassword.dart';
import 'screens/auth/otp.dart';
import 'screens/auth/register/register.dart';
import 'screens/auth/login/login.dart';

import 'mainPage.dart';
import 'screens/hotels/updateHotel.dart';
import 'screens/hotels/updateHotelPassword.dart';
import 'screens/hotels/updateRoom.dart';
import 'screens/hotels/viewBooking.dart';
import 'screens/admin/roomCrud/createRoom.dart';

import 'screens/user/editUser.dart';
import 'screens/user/user.dart';
import 'screens/user/updateUserPassword.dart';

import 'booking.dart';
import 'screens/admin/hotelDashboard/dashboard.dart';
import 'screens/hotels/hotelInfo.dart';
import 'screens/hotels/roomType.dart';

import 'screens/super admin/registeredUsers.dart';
import 'screens/super admin/registeredHotels.dart';

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
        'user': (context) => Profile(),
        //
        'booking': (context) => BookingPage(),
        'dashboard': (context) => Dashboard(),
        'hotelCrud': (context) => HotelCrud(),
        'hotelInfo': (context) => HotelInfo(),
        'roomCrud': (context) => RoomCreate(),
        'roomType': (context) => RoomType(),
        'updateHotel': (context) => UpdateHotel(),
        'updateRoom': (context) => UpdateRoom(),
        'getRooms': (context) => GetRooms(),
        'viewBooking': (context) => ViewBooking(),
        'getImage': (context) => ImageReceiver(),
        //
        'registeredUsers': (context) => RegisteredUsers(),
        'registeredHotels': (context) => RegisteredHotels(),

        //
        'editUser': (context) => EditUser(),
        'changeUserPassword': (context) => UpdateUserPassword(),
        'changeHotelPassword': (context) => UpdateManagerPassword(),
        'forgotPassword': (context) => ForgotPassword(),
        'otp': (context) => OTP(),
        'changePassword': (context) => ChangePassword(),

        'khalti': (context) => Khalti(),
      },
    );
  }
}
