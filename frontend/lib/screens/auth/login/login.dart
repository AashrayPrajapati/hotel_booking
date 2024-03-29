import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotel_booking/config.dart';
// import 'package:hotel_booking/utils.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

String selectedRole = 'User';

class _MyLoginState extends State<MyLogin> {
  bool notValidate = false;
  bool passwordVisible = true;

  final Dio _dio = Dio();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String userId = '';

  var role = ['User', 'Hotel Owner'];

  final _formKey = GlobalKey<FormState>();
  bool _isNotValidate = false;

  String? emailErrorText;
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter email';
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        emailErrorText = validateEmail(emailController.text);
      });
    });
  }

  void login() async {
    var regBody = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    String apiRole = '';

    if (selectedRole == 'User') {
      apiRole = '$apiUrl/users/login';
    } else if (selectedRole == 'Hotel Owner') {
      apiRole = '$apiUrl/hotel/login';
    }

    try {
      var response = await _dio.post(
        apiRole,
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
        data: jsonEncode(regBody),
      );

      if (response.data != null) {
        String responseData = response.data.toString();

        RegExp tokenRegex = RegExp(r'token: (.+)');
        Match? tokenMatch = tokenRegex.firstMatch(responseData);

        if (tokenMatch != null) {
          String token = tokenMatch.group(1) ?? '';
          // print(token); // Output: the extracted token value
          String? role = selectedRole;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwtToken', token);
          await prefs.setString('role', role);

          // Check if the token is saved in SharedPreferences
          String storedToken = prefs.getString('jwtToken') ?? '';
          String storedRole = prefs.getString('role') ?? '';

          print('Stored Token: $storedToken');
          print('Stored Token: $storedRole');

          Navigator.of(context, rootNavigator: true).pushNamed(
            'mainPage',
            arguments: {
              'userId': userId.toString(),
            },
          );

          print('this is the user id: ');
          print(userId);
        } else {
          // Handle case when token extraction fails

          // print('Token extraction failed');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(
                    child: Text('Invalid credentials',
                        style: TextStyle(color: Colors.red))),
                content: Text('Please check entered email or password',
                    textAlign: TextAlign.center),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(child: Text('OK')),
                  )
                ],
              );
            },
          );
        }
      } else {
        // Handle case when response data is null
        print('Response data is null');
      }
    } on DioError catch (e) {
      // Handle DioError or network-related errors
      print('Error connecting to server: ${e.message}');
      // Show error message to the user or handle the error appropriately

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/signP.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Welcome\nBack',
                          style: TextStyle(color: Colors.white, fontSize: 34),
                        ),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, 'mainPage');
                          },
                          icon: Icon(
                            Icons.close,
                            size: 37,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(23),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 23, right: 23, top: 11, bottom: 11),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sign in as",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  DropdownButton(
                                    elevation: 0,
                                    dropdownColor: Colors.transparent,
                                    isExpanded: false,
                                    // focusColor: Colors.blue,

                                    underline: Container(
                                      height: 1,
                                      color: Colors.transparent,
                                    ),

                                    // Initial Value
                                    value: selectedRole,

                                    icon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.white,
                                    ),

                                    // Array list of items
                                    items: role.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      );
                                    }).toList(),

                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedRole = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                style: TextStyle(color: Colors.white70),
                                decoration: InputDecoration(
                                    //
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    errorStyle: TextStyle(color: Colors.red),
                                    errorText: emailErrorText,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: validateEmail,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: passwordController,
                                style: TextStyle(color: Colors.white),
                                obscureText: passwordVisible,
                                decoration: InputDecoration(
                                  //
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorText: _isNotValidate
                                      ? "Enter correct password"
                                      : null,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, 'forgotPassword');
                                    },
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Sign in",
                                        style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 180, 216),
                                        child: IconButton(
                                          color: Colors.white,
                                          // onPressed: (() => {
                                          //       login(),
                                          //       print(notValidate),
                                          //       if (!notValidate) {

                                          //       }
                                          //     }),

                                          // onPressed: () {
                                          //   login();
                                          //   print(notValidate);
                                          // },

                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isNotValidate = false;
                                              });
                                              login();
                                            } else {
                                              setState(() {
                                                _isNotValidate = true;
                                              });
                                            }
                                          },

                                          icon: Icon(
                                            Icons.arrow_forward,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'register');
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Create a new account",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "?  ",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "Sign up",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    style: ButtonStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
