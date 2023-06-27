import 'package:flutter/material.dart';

// parse server sdk flutter
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hotel_booking/screens/hotels/getRoom.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
// import 'package:flutter/services.dart';

import 'package:hotel_booking/getImage.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import 'khalti/khalti.dart';
import 'khalti/khaltiPage.dart';
import 'screens/admin/hotelCrud/hotelCrud.dart';
import 'screens/auth/changePassword.dart';
import 'screens/auth/forgotPassword.dart';
import 'screens/auth/otp.dart';
import 'screens/auth/register/register.dart';
import 'screens/auth/login/login.dart';

import 'bottomNavbar.dart';
import 'screens/hotels/searchedHotels.dart';
import 'screens/hotels/updateHotel.dart';
import 'screens/hotels/updateHotelPassword.dart';
import 'screens/hotels/updateRoom.dart';
import 'screens/hotels/viewBooking.dart';
import 'screens/admin/roomCrud/createRoom.dart';

import 'screens/user/bookingHistory.dart';
import 'screens/user/editUser.dart';
import 'screens/user/user.dart';
import 'screens/user/updateUserPassword.dart';

import 'booking.dart';
import 'screens/admin/hotelDashboard/dashboard.dart';
import 'screens/hotels/hotelInfo.dart';
import 'screens/hotels/roomType.dart';

import 'screens/super admin/registeredUsers.dart';
import 'screens/super admin/registeredHotels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  final keyApplicationId = 'zmgZPvYhiw9iSwuwzgHAyPnvPc5n4WbP5vVNMwVK';
  final keyClientKey = '2xrGuDVVsTdlwmmr2vRxo7OLi8muvzZpn8GZc5am';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);
  var firstObject = ParseObject('FirstClass')
    ..set(
        'message', 'Hey ! First message from Flutter. Parse is now connected');
  await firstObject.save();

  print('....................done');
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: "test_public_key_081bd10255fa4631bd66953ed659a9c9",
        enabledDebugging: true,
        builder: (context, navKey) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyLogin(),
            navigatorKey: navKey,
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            routes: {
              'register': (context) => MyRegister(),
              'login': (context) => MyLogin(),
              //
              'mainPage': (context) => MainPage(),
              'user': (context) => Profile(),
              'bookingHistory': (context) => BookingHistory(),
              //
              'searchedHotels': (context) => SearchedHotelsPage(),
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
              'khaltiPage': (context) => KhaltiPage(),
            },
          );
        });
  }
}
