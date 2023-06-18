import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

int calculateNumberOfNights(DateTimeRange dateRange) {
  Duration difference = dateRange.end.difference(dateRange.start);
  return difference.inDays;
}

class Home extends StatelessWidget {
  const Home({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    jwtDecode();
    dateRangeInput.text = "";
    searchInput.text = "";
    super.initState();
  }

  TextEditingController dateRangeInput = TextEditingController();
  TextEditingController searchInput = TextEditingController();
  String numberOfNights = '';
  String formattedStartDate = '';
  String formattedEndDate = '';

  String userId = '';

  void jwtDecode() async {
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
    userId = payloadJson['_id'];
    print('Stored Role: $userRole');
    print('User ID: $userId');
  }

  void updateNumberOfNights(DateTimeRange pickedDateRange) {
    formattedStartDate = DateFormat('yyyy-MM-dd').format(pickedDateRange.start);
    formattedEndDate = DateFormat('yyyy-MM-dd').format(pickedDateRange.end);
    String formattedDateRange = '$formattedStartDate - $formattedEndDate';

    numberOfNights = calculateNumberOfNights(pickedDateRange).toString();
    setState(() {
      dateRangeInput.text = formattedDateRange;
    });

    // print("Start date: $formattedStartDate"); // Print the start date
    // print("End date: $formattedEndDate"); // Print the end date
    // print("Number of nights: $numberOfNights"); // Print the number of nights
  }

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/check.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'OpenSans',
          scaffoldBackgroundColor: Color.fromARGB(255, 244, 244, 244),
        ),
        home: Scaffold(
          // backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Color.fromARGB(255, 39, 92, 216),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            title: Text('yoHotel',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                )),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  // Container(
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width * 0.83,
                  //     child: TextField(
                  //       controller: searchInput,
                  //       decoration: InputDecoration(
                  //         prefixIcon: Icon(Icons.search_outlined),
                  //         contentPadding: EdgeInsets.symmetric(vertical: 10),
                  //         hintText: "City or hotels' name",
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(7),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(padding: EdgeInsets.only(bottom: 3)),
                  Container(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: TextField(
                          readOnly: true,
                          controller: dateRangeInput,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            hintText: 'Choose dates',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onTap: () async {
                            DateTimeRange? pickedDateRange =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(1937),
                              lastDate: DateTime(3333),
                              // dark theme for calendar
                              // builder: (context, child) {
                              //   return Theme(data: ThemeData.dark(), child: child!);
                              // },
                            );

                            if (pickedDateRange != null) {
                              // print(pickedDateRange);
                              String formattedStartDate =
                                  DateFormat('yyyy-MM-dd')
                                      .format(pickedDateRange.start);
                              String formattedEndDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDateRange.end);
                              String formattedDateRange =
                                  '$formattedStartDate - $formattedEndDate';
                              print('homePage');
                              print(formattedDateRange);

                              updateNumberOfNights(pickedDateRange);

                              setState(
                                () {
                                  dateRangeInput.text = formattedDateRange;
                                },
                              );
                            } else {
                              print("Date range is not selected");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 3)),
                  // Container(
                  //   child: Center(
                  //     child: SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.83,
                  //       child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Color.fromARGB(255, 39, 92, 216),
                  //         ),
                  //         child: Text('Search'),
                  //         onPressed: () async {
                  //           if (searchInput.text == "") {
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(SnackBar(
                  //               content:
                  //                   Text('Please enter city or hotel name'),
                  //               duration: Duration(seconds: 2),
                  //             ));
                  //           } else {
                  //             var dio = Dio();

                  //             var response = await dio.get(
                  //                 '$apiUrl/hotel/search?query=Sunny%20hotel%20Bhaktapur');
                  //             if (response.statusCode == 200) {
                  //               print(response.data);
                  //             } else {
                  //               print(response.statusCode);
                  //             }

                  //             if (response.statusCode == 200) {
                  //               print(response.data);
                  //               // Navigator.pushNamed(context, 'search',
                  //               //     arguments: response.data);
                  //             } else {
                  //               print(response.statusCode);
                  //             }
                  //           }
                  //           // Navigator.pushNamed(context, 'dashboard');
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 33),
                  Container(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          "Popular hotels around your location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.66,
                      child: FutureBuilder(
                        future: getHotels(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          var ID = snapshot.data[index]._id;
                                          if (formattedStartDate.isEmpty ||
                                              formattedEndDate.isEmpty) {
                                            print("Dates are not selected");
                                            // use fluttertoast package
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Please select check-in and check-out dates",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[400],
                                              textColor: Colors.white,
                                              fontSize: 17,
                                            );
                                          } else {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushNamed(
                                              'hotelInfo',
                                              arguments: {
                                                'userId': userId, // 'userId
                                                'id': ID,
                                                'numberOfNights':
                                                    numberOfNights.toString(),
                                                'startDate': formattedStartDate
                                                    .toString(),
                                                'endDate':
                                                    formattedEndDate.toString(),
                                              },
                                            );

                                            print("Specific hotel id: $ID");
                                            print(
                                                "Check-in date: $formattedStartDate"); // Print the start date
                                            print(
                                                "Check-out date: $formattedEndDate"); // Print the end date
                                            print(
                                                "Number of nights: $numberOfNights"); // Print the number of nights
                                            print('homePage');
                                          }
                                          // Print the user ID
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 100,
                                                child: Card(
                                                  elevation: 7,
                                                  child: Image.network(
                                                    'https://bit.ly/3KAjXJW',
                                                    fit: BoxFit.cover,
                                                  ),
                                                  // child: Placeholder(
                                                  //   fallbackHeight: 100,
                                                  //   fallbackWidth: 100,
                                                  // ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                height: 100,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 7,
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        bottom: 5,
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 5,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .propertyName,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          Expanded(
                                                            flex: 5,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              '${snapshot.data[index].streetName}, ${snapshot.data[index].city}',
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Dio _dio = Dio();

  Future<List<Hotel>> getHotels() async {
    try {
      final response = await _dio.get('$apiUrl/hotel/getHotels');

      List<Hotel> hotels = [];
      var jsonData = response.data;
      for (var data in jsonData) {
        Hotel hotel = Hotel(
          data['propertyName'],
          data['city'],
          data['streetName'],
          data['_id'],
        );
        hotels.add(hotel);
      }
      return hotels;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }
}

class Hotel {
  final String propertyName;
  final String city;
  final String streetName;
  final String _id;
  Hotel(
    this.propertyName,
    this.city,
    this.streetName,
    this._id,
  );
}
