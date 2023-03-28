import 'package:flutter/material.dart';
import '../screens/mainPage/mainPage.dart';
import '../screens/user/booking/booking.dart';
import '../screens/user/favorites/favorites.dart';

class BottomNavs extends StatefulWidget {
  const BottomNavs({super.key});
  @override
  State<BottomNavs> createState() => _BottomNavsState();
}

class _BottomNavsState extends State<BottomNavs> {
  List pages = [
    Home(),
    Booking(),
    Favorite(),
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
        // unselectedFontSize: 0,
        // selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: thisTap,
        currentIndex: thisIndex,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Admin Dashboard",
          ),
        ],
      ),
    );
  }
}
