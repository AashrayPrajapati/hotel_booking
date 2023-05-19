import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
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
    return Column(
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
        Text(
          'user1@gmail.com',
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
            color: HexColor('#f5f6fa'),
            child: ListTile(
              leading: Icon(
                Icons.menu_outlined,
                color: Colors.amber[700],
              ),
              title: Text('Edit Info'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.amber[700],
              ),
              onTap: () {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            color: HexColor('#f5f6fa'),
            child: ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.amber[700],
              ),
              title: Text('Log Out'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.amber[700],
              ),
              onTap: () async {
                Navigator.pushNamed(context, 'mainPage');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('jwtToken');
                prefs.remove('role');
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildOriginalUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                  backgroundColor: Color.fromARGB(255, 0, 191, 255),
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
                  backgroundColor: Color.fromARGB(255, 0, 191, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
