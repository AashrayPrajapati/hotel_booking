import 'package:flutter/material.dart';
import 'package:hotel_booking/home/home.dart';
import 'package:hotel_booking/favorites/favorites.dart';
import 'package:hotel_booking/booking/booking.dart';
import 'package:hotel_booking/user/user.dart';

class BottomNavs extends StatefulWidget {
  const BottomNavs({super.key});

  @override
  State<BottomNavs> createState() => _BottomNavsState();
}

class _BottomNavsState extends State<BottomNavs> {
  List pages = [
    Home(),
    Favorite(),
    Booking(),
    User(),
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
      backgroundColor: Colors.white,
      body: pages[thisIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
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
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "User",
          ),
        ],
      ),
    );
  }
}
