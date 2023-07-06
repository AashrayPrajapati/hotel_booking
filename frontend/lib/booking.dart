import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotel_booking/config.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'dart:convert';

final parseObject = ParseObject('Gallery');
var hId;

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

    var totalprice = int.parse(price!) * int.parse(numberOfNights!);
    print('bookingPage');
    print('Total price: $totalprice');
    print('User id: $userId');

    void book() async {
      try {
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
          print('Booking successful!');
          print('Response body: ${response.data}');
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
        } else {
          print('Booking failed. Response status code: ${response.statusCode}');
          print('Response body: ${response.data}');
        }
      } catch (e) {
        print('Error connecting to server: $e');
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
                  padding: const EdgeInsets.all(23),
                  child: FutureBuilder(
                    future: fetchImage(roomId!),
                    builder: ((context, snapshot) {
                      var varFile = snapshot.data?.get<ParseFileBase>('file');
                      print('.....${varFile?.url ?? 'hell'}');
                      if (varFile?.url?.isEmpty ?? true) {
                        return Placeholder(
                          fallbackWidth: 134,
                          fallbackHeight: 100,
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
                      Center(
                        child: Container(
                          width: 120,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-5]'),
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
                              hintText: 'No. of guests',
                            ),
                          ),
                        ),
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
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: HexColor('#FF265CD8'),
                          ),
                          onPressed: () {
                            book();
                          },
                          child: Text(
                            'Pay With Cash',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: Color.fromARGB(255, 87, 44, 138),
                        ),
                        onPressed: () {
                          // pass the total price to khaltiPage
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
                              'checkOutDate': endDate,
                            },
                          );

                          // Navigator.pushNamed(context, 'khaltiPage');
                        },
                        child: Text(
                          'Pay With Khalti',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
