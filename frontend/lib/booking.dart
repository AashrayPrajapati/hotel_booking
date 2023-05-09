import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// class Booking extends StatefulWidget {
//   const Booking({super.key});

//   @override
//   State<Booking> createState() => _BookingState();
// }

// class _BookingState extends State<Booking> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Stack(
//             children: [
//               Text('Booiing'),
//               bookRoom(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bookRoom(String id) {
//     print('ID: $id');
//   }
// }

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController userId = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();
  TextEditingController noOfGuests = TextEditingController();

  @override
  void dispose() {
    userId.dispose();
    checkIn.dispose();
    checkOut.dispose();
    noOfGuests.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String? id = ModalRoute.of(context)?.settings.arguments as String?;

    // Use the ID value here to fetch the booking details or do any other processing.

    void book() async {
      try {
        final Dio _dio = Dio();

        var regBody = {
          "user": "6412c87cd16ee5e7f1446f33",
          "hotel": "64365319012a04f615c9dcf0",
          "room": id,
          "checkInDate": "2023-05-26T14:30:00Z",
          "checkOutDate": "2023-05-28T10:00:00Z",
          "guests": noOfGuests.text,
          "totalPrice": 10000,
          "paymentStatus": "Pending"
        };
        print(regBody);

        var response = await _dio.post(
          // 'http://10.0.2.2:3000/bookRoom/book',
          'http://192.168.101.6:3000/bookRoom/book',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(regBody),
        );
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    }

    // dio.post
    return Scaffold(
      appBar: AppBar(title: Text('Booking details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Booking ID: $id'),
              TextField(
                controller: userId,
                decoration: InputDecoration(
                  hintText: 'Enter User ID',
                ),
              ),
              TextField(
                controller: checkIn,
                decoration: InputDecoration(
                  hintText: 'Enter check-in date',
                ),
              ),
              TextField(
                controller: checkOut,
                decoration: InputDecoration(
                  hintText: 'Enter check-out date',
                ),
              ),
              TextField(
                controller: noOfGuests,
                decoration: InputDecoration(
                  hintText: 'Enter number of guests',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // dio.post
                  book();
                  // print('ID: $id');
                  // print('User ID: ${userId.text}');
                  // print('Check-in: ${checkIn.text}');
                  // print('Check-out: ${checkOut.text}');
                  // print('No. of guests: ${noOfGuests.text}');
                },
                child: Text('Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
