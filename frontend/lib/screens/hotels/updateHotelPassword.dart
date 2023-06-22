import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/utils.dart';

class UpdateManagerPassword extends StatefulWidget {
  const UpdateManagerPassword({super.key});

  @override
  State<UpdateManagerPassword> createState() => UpdateManagerPasswordState();
}

class UpdateManagerPasswordState extends State<UpdateManagerPassword> {
  @override
  void initState() {
    decodeUser();
    super.initState();
  }

  final Dio _dio = Dio();

  void updatePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    if (newPassword != confirmPassword) {
      // isPasswordMatching = false;
      return
          // print('passwords doesnt match');
          showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Password Not Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Confirm Password does not match',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final String url = '$apiUrl/hotel/updatePassword/$ownerId';

    final response = await _dio.patch(
      url,
      data: {
        'password': oldPassword,
        'newPassword': newPassword,
      },
    );

    // print("hello this is repsonse of update password");
    print(response);
    // final responseText = response.toString();
    if (response.statusCode == 200) {
      print('Password Updated');
      // Navigator.pushNamed(context, 'user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Password Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            // responseText,
            'Password is updated',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'user');
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('Error updating password');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Password Not Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            // 'Password is not updated',
            // responseText,\
            'Password is not updated',

            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  bool isPasswordMatching = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Center(
              child: Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: oldPasswordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            labelText: 'Old Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: newPasswordController,
                          obscureText: _obscureText2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            labelText: 'New Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: _obscureText3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText3
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText3 = !_obscureText3;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        child: const Text('Update Password'),
                        onPressed: () {
                          updatePassword(
                            oldPasswordController.text,
                            newPasswordController.text,
                            confirmPasswordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          minimumSize: Size(130, 50),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
