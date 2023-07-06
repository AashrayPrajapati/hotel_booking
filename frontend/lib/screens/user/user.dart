import 'package:flutter/material.dart';

// import 'package:dio/dio.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:hotel_booking/screens/auth/login/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

// class UserInfo {
//   final String name;
//   final String email;

//   UserInfo(
//     this.name,
//     this.email,
//   );
// }

// final Dio _dio = Dio();

// Future<User> getUser(String id) async {
//   try {
//     final response = await _dio.get('$apiUrl/users/$id');

//     var jsonData = response.data;

//     UserInfo userInfo = UserInfo(
//       jsonData['name'] ?? '',
//       jsonData['email'] ?? '',
//     );

//     return userInfo;
//   } on DioError catch (e) {
//     print(e);

//     throw Exception("Error retrieving posts: ${e}");
//   }
// }

class _ProfileState extends State<Profile> {
  // double _initialRating = 4.5;
  // IconData? _selectedIcon;

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
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Card(
                color: Color.fromARGB(255, 232, 232, 232),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 7,
                child: Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 20,
                    //     bottom: 20,
                    //   ),
                    //   child: Center(
                    //     child: CircleAvatar(
                    //       // backgroundImage: AssetImage('assets/images/user.png'),
                    //       radius: 50,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 23,
                    ),
                    if (selectedRole == "Hotel Owner")
                      Text(
                        'Hotel Owner',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (selectedRole == "User")
                      Text(
                        'User',
                        style: TextStyle(
                          fontSize: 27,
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
                        bottom: 7,
                      ),
                      child: Card(
                        elevation: 3,
                        color: Color.fromARGB(255, 250, 250, 250),
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
                        bottom: 7,
                      ),
                      child: Card(
                        color: Color.fromARGB(255, 250, 250, 250),
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
                              //
                              selectedRole = 'User';
                            });
                            // const token = 'jwtToken';
                            // print(token);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 27,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOriginalUI() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              color: Color.fromARGB(255, 231, 231, 231),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 11,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'hotelCrud');
                        },
                        child: Text(
                          "List your property?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          minimumSize: Size(277, 53),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text(
                          "Login to your account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(277, 53),
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 23,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
