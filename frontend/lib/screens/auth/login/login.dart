import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:convert';
// import 'package:hotel_booking/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'config.dart';

class MyLogin extends StatefulWidget {
  // const MyLogin({Key? key}) : super(key: key);

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
  bool _isNotValidate = false;

  String userId = '';

  var role = ['User', 'Hotel Owner'];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void login() async {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      String apiRole = '';

      if (selectedRole == 'User') {
        apiRole = 'http://10.0.2.2:3000/users/login';
      } else if (selectedRole == 'Hotel Owner') {
        apiRole = 'http://10.0.2.2:3000/hotel/login';
      } else {
        // Handle the case when no role is selected or handle other roles
        return;
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
            String role = selectedRole;

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

            // Navigator.of(context, rootNavigator: true).pushNamed(
            //   'mainPage',
            //   arguments: {
            //     'userId': userId.toString(),
            //   },
            // );

            print('this is the user id: ');
            print(userId);
          } else {
            // Handle case when token extraction fails

            print('Token extraction failed');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Invalid email or password'),
                  content: Text('Please enter correct email or password'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid email or password',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/signP.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
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
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              //
                              filled: true,
                              fillColor: Colors.transparent,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText:
                                  _isNotValidate ? "Enter correct email" : null,

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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
                              errorStyle: TextStyle(color: Colors.white),
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
                                  color: Colors.black,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {},
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

                                      onPressed: () {
                                        login();
                                        print(notValidate);
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
                            height: 60,
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
                                          decoration: TextDecoration.underline,
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
