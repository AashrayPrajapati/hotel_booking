import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hotel_booking/config.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

final Dio _dio = Dio();

class _OTPState extends State<OTP> {
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  verifyOTP() async {
    if (otpController.text.isNotEmpty) {
      try {
        var regBody = {
          'otp': otpController.text,
        };
        print(regBody);
        var response = await _dio.post(
          '$apiUrl/auth/verify-otp',
          options: Options(headers: {'Content-Type': 'application/json'}),
          data: jsonEncode(regBody),
        );
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');

        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text('OTP Verified'),
                content: Text('OTP has been verified successfully'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'changePassword');
                    },
                    child: Center(child: Text('OK')),
                  ),
                ],
              );
            },
          );
        }
        // else {
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text('OTP Verification Failed'),
        //         content: Text('OTP verification failed. Please try again.'),
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             child: Text('OK'),
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }

        // Navigator.pushNamed(context, 'otp');

        // navigation logic
        // if (response.statusCode == 200) {
        //   Navigator.pushNamed(context, 'otp');
        // }
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('OTP Verification Failed'),
              content: Text('OTP verification failed. Please try again.'),
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text('Verify OTP'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // backgroundColor: Colors.white.withOpacity(0.93),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 69,
                    width: double.infinity,
                    color: Color.fromARGB(255, 241, 245, 249),
                    child: Padding(
                      padding: const EdgeInsets.all(19),
                      child: Text('Verify OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 71, 85, 105))),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 17, right: 17),
                    child: TextField(
                      controller: otpController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.allow(
                          RegExp('[0-9]'),
                        ),
                      ],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        labelText: 'Verify OTP',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      verifyOTP();
                      print('OTP: $otpController.text');
                      // Navigator.pushNamed(context, 'changePassword');
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 37),
                      backgroundColor: Color.fromARGB(255, 39, 92, 216),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
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
