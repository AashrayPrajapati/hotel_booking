import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ViewBooking extends StatefulWidget {
  const ViewBooking({Key? key}) : super(key: key);

  @override
  State<ViewBooking> createState() => _ViewBookingState();
}

class Bookings {
  final int guests;
  final int totalPrice;
  final String paymentStatus;
  final String checkInDate;
  final String checkOutDate;
  final String roomType;
  final String id;

  Bookings({
    required this.guests,
    required this.totalPrice,
    required this.paymentStatus,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomType,
    required this.id,
  });
}

class _ViewBookingState extends State<ViewBooking> {
  final Dio _dio = Dio();

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

    print('UPDATE ROOM PAGE');
    print('Stored Role: $userRole');
    print('USER ID: $ownerId');
  }

  @override
  void initState() {
    super.initState();
    jwtDecode();
  }

  Future<List<Bookings>> getBookings(String hotelId) async {
    try {
      List<Bookings> bookings = [];
      final bookingResponse =
          await _dio.get('$apiUrl/bookRoom/getBookings/$hotelId');

      var bookingData = bookingResponse.data;

      for (var data in bookingData) {
        Bookings booking = Bookings(
          guests: data['guests'],
          totalPrice: data['totalPrice'],
          roomType: data['roomType'],
          paymentStatus: data['paymentStatus'],
          checkInDate: DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(data['checkInDate'])),
          checkOutDate: DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(data['checkOutDate'])),
          id: data['_id'],
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
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? roomId = arguments['id'] as String?;
    print(roomId);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text(
            'View Booking',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Bookings>>(
          future: getBookings(ownerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Bookings> bookings = snapshot.data ?? [];

              if (bookings.isEmpty) {
                return Center(child: Text('No bookings available.'));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  Bookings booking = bookings[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Booking Details',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Guests: ${booking.guests}'),
                                    Text('Total Price: ${booking.totalPrice}'),
                                    Text(
                                        'Payment Status: ${booking.paymentStatus}'),
                                    Text(
                                        'CheckIn Date: ${booking.checkInDate}'),
                                    Text(
                                        'CheckOut Date: ${booking.checkOutDate}'),
                                    Text('Room Type: ${booking.roomType}'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                ListTile(
                                  leading: booking.paymentStatus == 'Pending'
                                      ? Text(
                                          'Unpaid',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          'Paid',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${booking.roomType}',
                                        style: TextStyle(
                                          // color: Color.fromARGB(
                                          //     255, 136, 136, 136),
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Text(
                                        'CheckIn Date: ${booking.checkInDate}',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          // color: Color.fromARGB(
                                          //     255, 136, 136, 136),
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        'CheckOut Date: ${booking.checkOutDate}',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 136, 136, 136),
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF555555),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
