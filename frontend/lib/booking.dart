import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotel_booking/khalti.dart';
import 'package:hotel_booking/khalti2.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController userId = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();
  TextEditingController noOfGuests = TextEditingController();

  String referenceId = "";

  @override
  void dispose() {
    userId.dispose();
    checkIn.dispose();
    checkOut.dispose();
    noOfGuests.dispose();
    super.dispose();
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          actions: [
            SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                  });

                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? roomName = arguments['roomName'] as String?;
    final String? price = arguments['price'] as String?;
    final String? roomId = arguments['roomId'] as String?;
    final String? hotelId = arguments['hotelId'] as String?;
    final String? numberOfNights = arguments['numberOfNights'] as String?;
    final String? startDate = arguments['startDate'] as String?;
    final String? endDate = arguments['endDate'] as String?;
    final String? userId = arguments['userId'] as String?;

    var totalprice = int.parse(price!) * int.parse(numberOfNights!);
    print('bookingPage');
    print('Total price: $totalprice');
    print('User id: $userId');

    // final String? id = ModalRoute.of(context)?.settings.arguments as String?;

    // Use the ID value here to fetch the booking details or do any other processing.

    KhaltiScope(
      publicKey: 'test_public_key_19908edd96ba473297852ed745f2f615',
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Khalti(),
          navigatorKey: navKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );

    void book() async {
      try {
        final Dio _dio = Dio();

        var regBody = {
          "user": userId,
          "hotel": hotelId,
          "room": roomId,
          "checkInDate": startDate,
          "checkOutDate": endDate,
          "guests": noOfGuests.text,
          "totalPrice": totalprice,
          "paymentStatus": "Pending"
        };
        print(regBody);

        var response = await _dio.post(
          // 'http://10.0.2.2:3000/bookRoom/book',
          'http://192.168.31.116:3000/bookRoom/book',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(regBody),
        );
        // var response = await _dio.post(
        //   options: Options(headers: {"Content-Type": "application/json"}),
        //   data: jsonEncode(regBody),
        // );
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    }

    return MaterialApp(
      theme: ThemeData(
        // fontFamily: 'OpenSans',
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            //replace with our own icon data.
          ),
          title: Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Center(
                  child: Text(
                    '$roomName Room',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      // color: Color.fromRGBO(52, 92, 125, 1),
                      color: HexColor('#345c7d'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Check-in date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '$startDate',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Check-out date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '$endDate',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
                      SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total length of stay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '$numberOfNights nights',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'Your price summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Card(
                  color: HexColor('#FFCADFFF'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: 33,
                            right: 33,
                          ),
                          child: Column(
                            children: [
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Total length of stay',
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //     Text(
                              //       '$numberOfNights nights',
                              //       style: TextStyle(
                              //         fontSize: 20,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rate per night',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$price',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                              SizedBox(height: 7),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total price',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    'NPR $totalprice',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      // TextField(
                      //   controller: userId,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     hintText: 'Enter User ID',
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      // QuantityInput(value: noOfGuests, onChanged: () ),
                      Center(
                        child: Container(
                          width: 120,
                          child: TextField(
                            style: TextStyle(
                              height: 1.0,

                              // fontSize: 18,
                              // fontWeight: FontWeight.w500,
                            ),
                            // cursorHeight: 25,

                            controller: noOfGuests,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: 'No. of guests',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: HexColor('#FF265CD8'),
                      ),
                      onPressed: () {
                        // book();
                        //
                        //
                        //
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          size: 30,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // payWithKhaltiInApp();
                                              // Navigator.pushNamed(
                                              //     context, 'khalti2');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Khalti2(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Pay with Khalti',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF572C8A),
                                              onPrimary: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                            ),
                                          ),
                                          // Text(referenceId),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              book();
                                            },
                                            child: Text(
                                              'Pay with Cash',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF265CD8),
                                              onPrimary: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
