import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/screens/auth/login/login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'dart:convert';

final parseObject = ParseObject('Gallery');
var hId;
var maxCapacity;
int numGuest = 0;
bool isBooked = false;

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController userId = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();
  TextEditingController noOfGuests = TextEditingController(text: '1');

  String referenceId = "";

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

  Future<ParseObject?> fetchImage(String roomId) async {
    QueryBuilder<ParseObject> queryBook = QueryBuilder<ParseObject>(parseObject)
      ..whereEqualTo('roomId', roomId)
      ..whereEqualTo('ownerId', hId);

    final ParseResponse responseBook = await queryBook.query();

    if (responseBook.success && responseBook.results != null) {
      return (responseBook.results?.first) as ParseObject;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? roomName = arguments['roomName'] as String?;
    final String? price = arguments['price'] as String?;
    final String? roomId = arguments['roomId'] as String?;
    final String? hotelId = arguments['hotelId'] as String?;
    hId = hotelId;
    final String? numberOfNights = arguments['numberOfNights'] as String?;
    final String? startDate = arguments['startDate'] as String?;
    final String? endDate = arguments['endDate'] as String?;
    final String? userId = arguments['userId'] as String?;
    final String? maxGuests = arguments['maxGuests'] as String?;
    maxCapacity = maxGuests;
    print('THIS IS THE MAX NUMBER OF PEOPLE IT CAN HOLD $maxGuests');

    var totalprice = int.parse(price!) * int.parse(numberOfNights!);
    numGuest = int.parse(noOfGuests.text);
    print('bookingPage');
    print('Total price: $totalprice');
    print('User id: $userId');

    void book() async {
      try {
        print(maxCapacity);
        print(numGuest);

        print(
            'sdxfghjkbhjkoladfbhnjfdsafdshaj;fdsabhnjfsdabhnjfdsasfdhajsfdyahiulqfnhajskd');
        final Dio _dio = Dio();

        var regBody = {
          "user": userId!,
          "hotel": hotelId!,
          "room": roomId!,
          "checkInDate": startDate!,
          "checkOutDate": endDate!,
          "guests": int.parse(noOfGuests.text),
          "totalPrice": totalprice,
          "paymentStatus": "Pending"
        };
        print(regBody);

        var response = await _dio.post(
          '$apiUrl/bookRoom/book',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: regBody,
        );

        if (response.statusCode == 200) {
          // Successful booking
          var responseData = response.data;
          // Process the responseData as needed
          print(responseData);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Booking successful 🎉',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                content: Text('Your booking has been confirmed.',
                    style: TextStyle(fontSize: 17)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'mainPage');
                    },
                    child: Center(child: Text('OK')),
                  ),
                ],
              );
            },
          );
        } else if (response.statusCode == 409) {
          // Booking failed
          var errorMessage = response.data["message"];
          // Handle the error message appropriately
          print("Status Code: ${response.statusCode}");
          print("Error Message: $errorMessage");
        } else {
          // Handle other status codes if needed
          print("Status Code: ${response.statusCode}");
          print("Response Body: ${response.data}");
        }
      } catch (e) {
        // Handle the error
        print('Error connecting to the server: $e');
        //show a sialog box with a message that the server is not responding
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  'Booking failed',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                  'The room is already booked during the selected dates',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'mainPage');
                  },
                  child: Center(child: Text('OK')),
                ),
              ],
            );
          },
        );
      }
    }

    Future bookWithKhalti() async {
      try {
        print(maxCapacity);
        print(numGuest);

        print(
            'sdxfghjkbhjkoladfbhnjfdsafdshaj;fdsabhnjfsdabhnjfdsasfdhajsfdyahiulqfnhajskd');
        final Dio _dio = Dio();

        var regBody = {
          "user": userId!,
          "hotel": hotelId!,
          "room": roomId!,
          "checkInDate": startDate!,
          "checkOutDate": endDate!,
          "guests": int.parse(noOfGuests.text),
          "totalPrice": totalprice,
          "paymentStatus": "Pending"
        };
        print(regBody);

        var response = await _dio.post(
          '$apiUrl/bookRoom/existingbooking',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: regBody,
        );

        if (response.statusCode == 200) {
          // Successful booking
          Navigator.of(context, rootNavigator: true).pushNamed(
            'khaltiPage',
            arguments: {
              'userId': userId,
              'hotelId': hotelId,
              'roomId': roomId,
              'roomName': roomName,
              'totalPrice': totalprice,
              'noOfGuests': noOfGuests.text,
              'checkInDate': startDate,
              'checkOutDate': endDate
            },
          );
          var responseData = response.data;
          // Process the responseData as needed
          print(responseData);
        } else if (response.statusCode == 409) {
          // Booking failed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(
                  child: Text(
                    'Booking failed',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                content: Text(
                    'The room is already booked during the selected dates',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'mainPage');
                    },
                    child: Center(child: Text('OK')),
                  ),
                ],
              );
            },
          );
          var errorMessage = response.data["message"];
          // Handle the error message appropriately
          print("Status Code: ${response.statusCode}");
          print("Error Message: $errorMessage");
        } else {
          // Handle other status codes if needed
          print("Status Code: ${response.statusCode}");
          print("Response Body: ${response.data}");
        }
      } catch (e) {
        // Handle the error
        print('Error connecting to the server: $e');
        //show a sialog box with a message that the server is not responding
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  'Booking failed',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                  'The room is already booked during the selected dates',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'mainPage');
                  },
                  child: Center(child: Text('OK')),
                ),
              ],
            );
          },
        );
      }
    }

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
            icon: Icon(Icons.arrow_back_ios_new),
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
                      color: HexColor('#345c7d'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 7, right: 7),
                  child: FutureBuilder(
                    future: fetchImage(roomId!),
                    builder: ((context, snapshot) {
                      var varFile = snapshot.data?.get<ParseFileBase>('file');
                      print('.....${varFile?.url ?? 'hell'}');
                      if (varFile?.url?.isEmpty ?? true) {
                        return Placeholder(
                          fallbackWidth: 500,
                          fallbackHeight: 200,
                        );
                      }
                      return Image.network(
                        varFile?.url ?? "",
                        width: 500,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    }),
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
                      SizedBox(height: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Max guests',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '${maxGuests}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
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
                      SizedBox(height: 15),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: 33,
                            right: 33,
                          ),
                          child: Column(
                            children: [
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    'NRs.$totalprice',
                                    style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[890],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 17),
                              // Divider(
                              //   thickness: 1,
                              //   color: Colors.black54,
                              // ),
                              // SizedBox(height: 7),
                              Expanded(
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(),
                                  //   borderRadius: BorderRadius.circular(15),
                                  //   // color: Colors.grey[200],
                                  // ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "*15% discount on paying with Khalti and\n No refund if you cancel your booking.",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromARGB(255, 255, 14, 14),
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'No. of guests',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Container(
                            width: 120,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.allow(
                                  RegExp('[1-9]'),
                                ),
                              ],
                              style: TextStyle(
                                height: 1.0,
                              ),
                              controller: noOfGuests,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // hintText: '1',
                                // labelText: 'No. of guests',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          child: Text(
                            'Pay With Cash',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: HexColor('#FF265CD8'),
                          ),
                          onPressed: () {
                            if (selectedRole == 'Hotel Owner') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Center(
                                      child: Text(
                                        'Login as user',
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    content: Text(
                                        'Logged in as a hotel owner,\nneed to login as a user',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17)),
                                    actions: [
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, 'login');
                                          },
                                          child: Text('Login Now'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            }

                            //check if userId exists
                            if (userId == null || userId.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      'Login Required',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text('Please login first.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'login');
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Exit the function if userId is empty
                            } else if (int.parse(maxCapacity) < numGuest) {
                              print('exit the fucntion if userid is empty');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      'Booking failed',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                        'The number of guests exceeds the maximum capacity of the room.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Center(child: Text('OK')),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return;
                            } else {
                              print('this is the selected guest $numGuest');
                              book();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        child: Text(
                          'Pay With Khalti',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: Color.fromARGB(255, 87, 44, 138),
                        ),
                        onPressed: () {
                          if (selectedRole == 'Hotel Owner') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Center(
                                    child: Text(
                                      'Login as user',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Text(
                                      'Logged in as a hotel owner,\nneed to login as a user',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 17)),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'login');
                                        },
                                        child: Text('Login Now'),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          //check if userId exists
                          if (userId == null || userId.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'Login Required',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text('Please login first.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, 'login');
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return; // Exit the function if userId is empty
                          } else if (int.parse(maxCapacity) < numGuest) {
                            print('exit the fucntion if userid is empty');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'Booking failed',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(
                                      'The number of guests exceeds the maximum capacity of the room.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 17)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Center(child: Text('OK')),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          } else {
                            bookWithKhalti();
                            // if (bookWithKhalti() == false) {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //       title: Center(
                            //         child: Text(
                            //           'Booking failed',
                            //           style: TextStyle(
                            //               fontSize: 23,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //       ),
                            //       content: Text(
                            //           'The room is already booked during the selected dates',
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(fontSize: 17)),
                            //       actions: [
                            //         TextButton(
                            //           onPressed: () {
                            //             Navigator.pushNamed(
                            //                 context, 'mainPage');
                            //           },
                            //           child: Center(child: Text('OK')),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                            // Navigator.of(context, rootNavigator: true)
                            //     .pushNamed(
                            //   'khaltiPage',
                            //   arguments: {
                            //     'userId': userId,
                            //     'hotelId': hotelId,
                            //     'roomId': roomId,
                            //     'roomName': roomName,
                            //     'totalPrice': totalprice,
                            //     'noOfGuests': noOfGuests.text,
                            //     'checkInDate': startDate,
                            //     'checkOutDate': endDate
                            //   },
                            // );
                            // }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
