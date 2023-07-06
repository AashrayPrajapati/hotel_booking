import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

final Dio _dio = Dio();

class Booking {
  final String roomType;
  final String checkInDate;
  final String checkOutDate;
  final int totalPrice;
  final String paymentStatus;

  Booking({
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.paymentStatus,
  });
}

class _BookingHistoryState extends State<BookingHistory> {
  String ownerId = '';

  Future<void> jwtDecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedToken = prefs.getString('jwtToken') ?? '';
    String userRole = prefs.getString('role') ?? '';

    // Decode the stored token
    List<String> tokenParts = storedToken.split('.');
    String encodedPayload = tokenParts[1];
    String decodedPayload = utf8.decode(base64Url.decode(encodedPayload));

    // Parse the decoded payload as JSON
    Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);

    // Access the token claims from the payload
    setState(() {
      ownerId = payloadJson['_id'];
    });

    print('BOOKING HISTORY PAGE');
    print('Stored Role: $userRole');
    print('USER ID: $ownerId');
  }

  @override
  void initState() {
    jwtDecode();
    super.initState();
  }

  Future<List<Booking>> getBooking(String userID) async {
    try {
      print('sdfgsdfgUSER ID: $userID');

      if (userID == '') {
        // throw Exception('User ID is empty.');
        // Text('User ID is empty.');
        return [];
      }
      List<Booking> bookings = [];

      final bookingResponse =
          await _dio.get('$apiUrl/bookRoom/getBookingsByUser/$userID');

      var bookingData = bookingResponse.data;

      for (var data in bookingData) {
        Booking booking = Booking(
          roomType: data['roomType'],
          checkInDate:
              DateFormat('dd-MM-y').format(DateTime.parse(data['checkInDate'])),
          checkOutDate: DateFormat('dd-MM-y')
              .format(DateTime.parse(data['checkOutDate'])),
          totalPrice: data['totalPrice'],
          paymentStatus: data['paymentStatus'],
        );
        bookings.add(booking);
        print(bookings);
      }

      return bookings;
    } on DioError catch (e) {
      throw Exception("Error retrieving bookings: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
            icon: Icon(Icons.arrow_back_ios_new),
            //replace with our own icon data.
          ),
          title: Text(
            'Booking History',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Booking>>(
          future: getBooking(ownerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Booking> bookings = snapshot.data ?? [];

              if (bookings.isEmpty) {
                return Center(child: Text('No bookings available.'));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  Booking booking = bookings[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context, rootNavigator: true)
                            //     .pushNamed(
                            //   'updateRoom',
                            //   arguments: {
                            //     'roomType': booking.roomType,
                            //   },
                            // );

                            // show dialog containing booking history
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  title: Center(
                                    child: Text(
                                      'Booking History',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    'Room Type: ${booking.roomType}\nCheck-in: ${booking.checkInDate}\nCheck-out: ${booking.checkOutDate}\nTotal Price: ${booking.totalPrice}\nPayment Status: ${booking.paymentStatus}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Cancel Booking',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            color: Color.fromARGB(255, 76, 120, 223),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 17,
                                right: 17,
                                top: 17,
                                bottom: 17,
                              ),
                              child: ListTile(
                                title: Text(
                                  booking.roomType,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                subtitle: Text(
                                  'Check-in: ${booking.checkInDate}\nCheck-out: ${booking.checkOutDate}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
