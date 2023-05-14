import 'package:flutter/material.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'), // OPEN-SANS FONT STYLE

      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text(
            'yoHotel',
            style: TextStyle(
              // color: Color.fromARGB(255, 34, 150, 243),
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
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
                            text: "List your property ?",
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
                      // add rounded corners
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
                            text: "Already have an account ?",
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
        ),
      ),
    );
  }
}
