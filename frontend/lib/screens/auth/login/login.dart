import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
// import 'config.dart';

class MyLogin extends StatefulWidget {
  // const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool passwordVisible = true;

  final Dio _dio = Dio();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  String selectedRole = 'User';

  var role = ['User', 'Admin'];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      print(regBody);
      try {
        var response = await _dio.post(
          // 'http://10.0.2.2:3000/users/register',
          'http://192.168.10.78:3000/users/register',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(regBody),
        );
        // var response = await _dio.post(
        //   options: Options(headers: {"Content-Type": "application/json"}),
        //   data: jsonEncode(regBody),
        // );
        print(response.data);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    } else {
      setState(() {
        print("Ay Yo");
        _isNotValidate = true;
      });
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
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Your role",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.arrow_right_alt, color: Colors.white),
                              DropdownButton(
                                underline: Container(
                                  height: 1,
                                  color: Colors.white,
                                ),

                                // Initial Value
                                value: selectedRole,

                                // Down Arrow Icon
                                icon: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.black,
                                ),

                                // Array list of items
                                items: role.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRole = newValue!;
                                    // print('You are $selectedRole');
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              //
                              filled: true,
                              fillColor: Colors.transparent,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText:
                                  _isNotValidate ? "Enter correct email" : null,
                              //
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
                            style: TextStyle(color: Colors.white),
                            obscureText: passwordVisible,
                            decoration: InputDecoration(
                              //
                              filled: true,
                              fillColor: Colors.transparent,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText:
                                  _isNotValidate ? "Enter full name" : null,
                              //
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
                                      onPressed: () {
                                        print('You are $selectedRole');
                                        Navigator.pushNamed(
                                            context, 'mainPage');
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
