import 'package:flutter/material.dart';

import 'package:hotel_booking/screens/admin/roomCrud/createRoom.dart';
import 'package:hotel_booking/screens/auth/login/login.dart';
import 'screens/hotels/getRoom.dart';
import 'screens/mainPage/home.dart';
import 'package:hotel_booking/screens/user/bookingHistory.dart';
import 'screens/user/settings.dart';
import 'screens/user/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    Home(),
    if (selectedRole == "Hotel Owner")
      RoomCreate()
    else if (selectedRole == "User")
      BookingHistory()
    else if (selectedRole == "")
      userSettings(),
    if (selectedRole == "Hotel Owner") GetRooms(),
    Profile(),
  ];
  int thisIndex = 0;
  void thisTap(int index) {
    setState(() {
      thisIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[thisIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        // unselectedFontSize: 0,
        // selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: thisTap,
        currentIndex: thisIndex,
        selectedItemColor: Color.fromARGB(255, 74, 128, 255),
        unselectedItemColor: Colors.black54,
        // unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          if (selectedRole == "Hotel Owner")
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Create rooms",
            ),
          if (selectedRole == "Hotel Owner")
            BottomNavigationBarItem(
              icon: Icon(Icons.hotel_outlined),
              label: "Rooms",
            ),
          if (selectedRole == "User")
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: "Booking History",
            ),
          // else if (selectedRole == null)
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.settings_outlined),
          //     label: "Settings",
          //   ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: "User",
          ),
        ],
      ),
    );
  }
}
