import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

final Dio _dio = Dio();

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  sendOTP() async {
    if (emailController.text.isNotEmpty) {
      try {
        var regBody = {
          'email': emailController.text,
        };
        print(regBody);
        var response = await _dio.post(
          '$apiUrl/auth/forgotpassword',
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: jsonEncode(regBody),
        );
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');
        //
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent dialog from being dismissed by tapping outside
            builder: (BuildContext context) {
              // Show the dialog
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushNamed(context, 'otp'); // Navigate to 'otp' page
              });
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(
                  child: Text(
                    'OTP Sent!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Text('OTP has been sent to your email'),
                actions: [
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop(); // Dismiss the dialog
                  //   },
                  //   child: Center(child: Text('OK')),
                  // ),
                  SizedBox(height: 3),
                ],
              );
            },
          );
        }

        // Navigator.pushNamed(context, 'otp');

        // navigation logic
        // if (response.statusCode == 200) {
        //   Navigator.pushNamed(context, 'otp');
        // }
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text('Forgot Password'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
          ),
        ),
        // backgroundColor: Colors.white.withOpacity(0.93),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: Card(
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('Send OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 71, 85, 105),
                      )),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 17, right: 17),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  ElevatedButton(
                    onPressed: () {
                      sendOTP();
                      print(emailController.text);
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(123, 50),
                      backgroundColor: Color.fromARGB(255, 39, 92, 216),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
