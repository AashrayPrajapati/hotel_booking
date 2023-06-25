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
  String selectedValue = '';
  String numberOfNights = '';
  String formattedStartDate = '';
  String formattedEndDate = '';

  String userId = '';

  void updateSelectedValue(String? value) {
    setState(() {
      selectedValue = value ?? ''; // Update the selectedValue variable
    });
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 238, 238, 238),
        ),
        home: Scaffold(
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Color.fromARGB(255, 39, 92, 216),
            title: Text('yoHotel',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                )),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 15),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: TextField(
                                  controller: searchInput,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search_outlined,
                                        color: Colors.black),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    hintText: "Search",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: BorderSide(
                                          color: Colors
                                              .black), // Set the border color
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                flex: 2,
                                child: dropDown(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: TextField(
                            readOnly: true,
                            controller: dateRangeInput,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
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
                              );

                              if (pickedDateRange != null) {
                                // print(pickedDateRange);
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(pickedDateRange.start);
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd')
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
                    searchBySelectedValue(context),
                    SizedBox(height: 13),
                    hotelApi(context, searchInput.text, selectedValue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton searchBySelectedValue(BuildContext context) => ElevatedButton(
        child: Text('Search',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.37, 40),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
            'searchedHotels',
            arguments: {
              'userId': userId,
              'searchInput': searchInput.text,
              'selectedValue': selectedValue,
              'numberOfNights': numberOfNights.toString(),
              'startDate': formattedStartDate.toString(),
              'endDate': formattedEndDate.toString(),
            },
          );
        },
      );

  Container dropDown() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 39, 92, 216),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        icon: Icon(Icons.filter_alt_outlined,
            color: Color.fromARGB(255, 255, 255, 255)),
        items: [
          DropdownMenuItem<String>(
            child: Center(
              child: Icon(Icons.location_on_outlined,
                  color: Color.fromARGB(255, 39, 92, 216)),
            ),
            value: 'location',
          ),
          DropdownMenuItem<String>(
            child: Center(
              child: Icon(Icons.home_outlined,
                  color: Color.fromARGB(255, 39, 92, 216)),
            ),
            value: 'home',
          ),
        ],
        onChanged: (String? value) {
          setState(() {
            selectedValue = value ?? ''; // Update the selectedValue variable
          });
        },
      ),
    );
  }

  Container hotelApi(
      BuildContext context, String searchInput, String selectedValue) {
    print('hotelApihotelApihotelApihotelApihotelApihotelApihotelApi');
    // print(selectedValue);
    print("this is from the hotelAPI===$searchInput");
    print("this is from the hotelAPI===$selectedValue");
    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      child: FutureBuilder(
        future: getHotels(searchInput, selectedValue),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 7,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          var ID = snapshot.data[index]._id;
                          if (formattedStartDate.isEmpty ||
                              formattedEndDate.isEmpty) {
                            print("Dates are not selected");
                            // use fluttertoast package
                            Fluttertoast.showToast(
                              msg: "Please select check-in and check-out dates",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red[400],
                              textColor: Colors.white,
                              fontSize: 17,
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              'hotelInfo',
                              arguments: {
                                'userId': userId, // 'userId
                                'id': ID,
                                'numberOfNights': numberOfNights.toString(),
                                'startDate': formattedStartDate.toString(),
                                'endDate': formattedEndDate.toString(),
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
                            hotelImage(),
                            hotelDetails(snapshot, index),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Expanded hotelImage() {
    return Expanded(
      flex: 4,
      child: Container(
        height: 100,
        child: Card(
          child: Image.network(
            'https://bit.ly/3KAjXJW',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Expanded hotelDetails(AsyncSnapshot<dynamic> snapshot, int index) {
    return Expanded(
      flex: 6,
      child: Container(
        height: 100,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(11),
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
              bottomRight: Radius.circular(11),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          snapshot.data[index].propertyName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
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
    );
  }

  final Dio _dio = Dio();

  Future<List<Hotel>> getHotels(
      String searchInput, String selectedValue) async {
    // future: getHotels(searchInput, selectedValue),

    try {
      Map<String, dynamic> requestData = {};

      // print('asdfhsahdkhakjahfkjasdfhaskjdfsahdkjfshfkjasdfhaskfjsahf');
      print(selectedValue);
      print(searchInput);
      // print('asdfhsahdkhakjahfkjasdfhaskjdfsahdkjfshfkjasdfhaskfjsahf');

      if (selectedValue == 'location') {
        print('locationnn');
        requestData['city'] = searchInput;
      } else if (selectedValue == 'home') {
        print('homeee');
        requestData['propertyName'] = searchInput;
      }

      final response = await _dio.get(
        '$apiUrl/hotel/getHotels',
        // data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

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
      print('hotels.length');
      print(hotels.length);
      return hotels;
    } on DioError catch (e) {
      throw Exception("Error retrieving hotels: ${e.message}");
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
