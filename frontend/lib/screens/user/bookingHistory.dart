import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/utils.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

final Dio _dio = Dio();

class _BookingHistoryState extends State<BookingHistory> {
  @override
  void initState() {
    decodeUser();
    super.initState();
  }

  getBookingHistory() async {
    try {
      var response = await _dio.get(
        '$apiUrl/booking-history',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.data}');
    } on DioError catch (e) {
      print('Error connecting to server: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pushNamed(context, 'mainPage');
              },
            ),
            backgroundColor: Color.fromARGB(255, 39, 92, 216),
            title: Text(
              'Booking History',
              style: TextStyle(
                // color: Color.fromARGB(255, 34, 150, 243),
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [],
          )),
    );
  }
}
