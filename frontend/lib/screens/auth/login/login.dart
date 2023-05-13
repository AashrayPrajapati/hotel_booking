import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:convert';
import 'package:hotel_booking/mainPage.dart';
// import 'config.dart';

class MyLogin extends StatefulWidget {
  // const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool notValidate = false;
  bool passwordVisible = true;

  final Dio _dio = Dio();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  String selectedRole = 'User';

  var role = ['User', 'Hotel Owner'];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    // if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    var regBody = {
      "email": emailController.text,
      "password": passwordController.text
    };
    print(regBody);

    String apiRole = '';

    if (selectedRole == 'User') {
      // API endpoint for User role
      apiRole = 'http://192.168.10.78:3000/users/login';
    } else if (selectedRole == 'Hotel Owner') {
      // API endpoint for Hotel Owner role
      apiRole = 'http://192.168.10.78:3000/hotel/login';
    } else {
      // Handle the case when no role is selected or handle other roles
      return;
    }

    try {
      var response = await _dio.post(
        // 'http://10.0.2.2:3000/users/login',
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
          print(token); // Output: the extracted token value

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        } else {
          notValidate = true;
        }
      } else {
        print('Response data is null');
      }
    } on DioError catch (e) {
      print('Error connecting to server: ${e.message}');
      // }
      // } else {
      //   setState(() {
      //     _isNotValidate = true;
      //   });
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
                                        if (notValidate) {
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "Invalid email or password",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
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
