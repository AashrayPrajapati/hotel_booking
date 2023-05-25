import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotel_booking/screens/auth/login/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class Hotel {
  final String propertyName;
  final String streetName;
  final String city;
  final String description;
  final String password;

  Hotel(
    this.propertyName,
    this.streetName,
    this.city,
    this.description,
    this.password,
  );
}

class _UserState extends State<User> {
  final Dio _dio = Dio();

  // double _initialRating = 4.5;
  // IconData? _selectedIcon;

  Future<Hotel> getHotel(String id) async {
    try {
      final response =
          await _dio.get('http://10.0.2.2:3000/hotel/getHotel/$id');

      var jsonData = response.data;

      Hotel hotel = Hotel(
        jsonData['propertyName'] ?? '',
        jsonData['streetName'] ?? '',
        jsonData['city'] ?? '',
        jsonData['description'] ?? '',
        jsonData['password'] ?? '',
      );

      return hotel;
    } on DioError catch (e) {
      print(e);

      throw Exception("Error retrieving posts: ${e}");
    }
  }

  String userId = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    checkStoredToken();
  }

  Future<void> checkStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedToken = prefs.getString('jwtToken') ?? '';
    String userRole = prefs.getString('role') ?? '';

    if (storedToken.isNotEmpty) {
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

      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedToken = prefs.getString('jwtToken') ?? '';
    String userRole = prefs.getString('role') ?? '';

    if (storedToken.isNotEmpty) {
      // Decode the stored token
      List<String> tokenParts = storedToken.split('.');
      String encodedPayload = tokenParts[1];
      String decodedPayload = utf8.decode(base64Url.decode(encodedPayload));

      // Parse the decoded payload as JSON
      Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);

      // Access the token claims from the payload
      userId = payloadJson['_id'];
      print('Stored Role: $userRole');
      print(
          'User ID: $userId'); //yo id use garera user ko info fetch garnu parxa admin xa bhani chai Hotel name dekhuni
      //create a seperate file for handling jwt token and user info

      setState(() {
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        backgroundColor: HexColor('#fafafa'),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
          ),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text(
            'yoHotel',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoggedIn ? buildLoggedInUI() : buildOriginalUI(),
      ),
    );
  }

  Widget buildLoggedInUI() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      // backgroundImage: AssetImage('assets/images/user.png'),
                      radius: 50,
                    ),
                  ),
                ),
                if (selectedRole == "Hotel Owner")
                  Text(
                    'Hotel Owner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (selectedRole == "User")
                  Text(
                    'User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    // color: Color(0xf5f6fa),
                    child: ListTile(
                      leading: Icon(
                        Icons.menu_outlined,
                        color: Color.fromARGB(255, 39, 92, 216),
                      ),
                      title: Text('Edit Info'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 39, 92, 216),
                      ),
                      onTap: () {
                        if (selectedRole == "Hotel Owner")
                          Navigator.pushNamed(context, 'updateHotel',
                              arguments: {
                                'id': userId,
                              });
                        else
                          Navigator.pushNamed(context, 'editUser');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.logout_outlined,
                        color: Color.fromARGB(255, 39, 92, 216),
                      ),
                      title: Text('Log Out'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 39, 92, 216),
                      ),
                      onTap: () async {
                        Navigator.pushNamed(context, 'mainPage');
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('jwtToken');
                        prefs.remove('role');
                        setState(() {
                          isLoggedIn = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOriginalUI() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Container(
                      width: 250,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'hotelCrud');
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            children: [
                              TextSpan(
                                text: "List your property",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 250,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                            children: [
                              TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
