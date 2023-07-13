import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:hotel_booking/config.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_picker/csc_picker.dart';
// import 'package:flutter/services.dart';

class HotelCrud extends StatefulWidget {
  const HotelCrud({super.key});
  @override
  State<HotelCrud> createState() => HotelCrudState();
}

class HotelCrudState extends State<HotelCrud> {
  final Dio _dio = Dio();

  final cloudinary = CloudinaryPublic('dgrkvnovb', 'ml_default', cache: false);

  bool passwordVisible = true;

  String ownerId = '';

  TextEditingController ownerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController propertyNameController = TextEditingController();
  //
  TextEditingController countryController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  //
  TextEditingController stateController = TextEditingController();
  //  TextEditingController postalCodeController = TextEditingController();
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  //
  TextEditingController descriptionController = TextEditingController();
  bool _isNotValidate = false;

  bool validateEmail(String email) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool validatePassword(String password) {
    // Password validation rules
    final minLength = 7;
    // final hasUppercase = RegExp(r'[A-Z]');
    // final hasLowercase = RegExp(r'[a-z]');
    // final hasDigits = RegExp(r'\d');

    if (password.isEmpty) {
      return false; // Password is empty
    }

    if (password.length < minLength) {
      return false; // Password length is less than the minimum required
    }

    // if (!hasUppercase.hasMatch(password)) {
    //   return false; // Password does not contain an uppercase letter
    // }

    // if (!hasLowercase.hasMatch(password)) {
    //   return false; // Password does not contain a lowercase letter
    // }

    // if (!hasDigits.hasMatch(password)) {
    //   return false; // Password does not contain a digit
    // }

    return true; // Password is valid
  }

  void registerHotel() async {
    if (ownerNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        propertyNameController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        streetNameController.text.isNotEmpty &&
        // postalCodeController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      if (!validateEmail(emailController.text)) {
        setState(() {
          _isNotValidate = true;
        });
        return showDialog(
          // barrierDismissible: false, // user must tap button!
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(child: Text("Invalid email!")),
              content: Text("Please enter valid email.",
                  textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(child: Text("Ok")),
                ),
              ],
            );
          },
        );
      }
      if (!validatePassword(passwordController.text)) {
        showDialog(
          // barrierDismissible: false, // user must tap button!
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text("Invalid password!")),
              content: Text("Password must contain at least 7 characters"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
        return;
      }

      var regBody = {
        "ownerName": ownerNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "propertyName": propertyNameController.text,
        "country": countryController.text,
        "city": cityController.text,
        "postalCode": "1000",
        "streetName": streetNameController.text,
        "description": descriptionController.text,
      };
      print(regBody);
      try {
        var response = await _dio.post(
          '$apiUrl/hotel/register',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(regBody),
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');

        if (response.statusCode == 200) {
          showDialog(
            // barrierDismissible: false, // user must tap button!

            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Center(
                    child: Text(
                  "Hotel registered successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                content: Text(
                  "Please login to continue.",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Center(child: Text("Ok")),
                  ),
                ],
              );
            },
          );
        } else if (response.statusCode == 400) {
          showDialog(
            // barrierDismissible: false, // user must tap button!
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Invalid credentials!")),
                content: Text("Please try again."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        }
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  void jwtDecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedToken = prefs.getString('jwtToken') ?? '';
    String userRole = prefs.getString('role') ?? '';

    // Decode the stored token
    List<String> tokenParts = storedToken.split('.');
    String encodedPayload = tokenParts[1];
    String decodedPayload = utf8.decode(base64Url.decode(encodedPayload));

    // Parse the decoded payload as JSON
    Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);

    // Access the token claims from the payload
    ownerId = payloadJson['_id'];
    print('Stored Role: $userRole');
    print('USER ID: $ownerId');
  }

  @override
  void dispose() {
    ownerNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    propertyNameController.dispose();
    countryController.dispose();
    cityController.dispose();
    // postalCodeController.dispose();
    streetNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    jwtDecode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(fontFamily: 'OpenSans'),
        home: Scaffold(
            // backgroundColor: Color.fromARGB(255, 238, 238, 238),
            appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 39, 92, 216),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'mainPage');
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('Create Hotel',
                    style: TextStyle(
                        // color: Color.fromARGB(255, 34, 150, 243),
                        fontSize: 25,
                        fontWeight: FontWeight.w600))),
            body: SingleChildScrollView(
                child: Column(children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
              //   child: Text("Create Hotel",
              //       style:
              //           TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              // ),
              Padding(
                padding: const EdgeInsets.all(17),
                child: Card(
                  color: Color.fromARGB(255, 238, 238, 238),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        ownerName(),
                        email(),
                        password(),
                        // Divider(color: Colors.black38),
                        propertyName(),
                        country(),
                        city(),
                        // _buildCSCPicker(),
                        streetName(),

                        // postalCode(),
                        description(),
                        SizedBox(height: 23),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 50),
                            backgroundColor: Color.fromARGB(255, 39, 92, 216),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23),
                            ),
                          ),
                          onPressed: () {
                            print('Selected country: $selectedCountry');
                            print('Selected state: $selectedState');
                            print('Selected city: $selectedCity');

                            // main part below
                            registerHotel();
                          },
                          child: Text("Next", style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(height: 13),
                      ]),
                ),
              )
            ]))));
  }

  Padding postalCode() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
      child: TextField(
        // controller: postalCodeController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 15, height: 0.7),
        decoration: InputDecoration(
          //
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(color: Colors.red),
          errorText: _isNotValidate ? "Enter full name" : null,
          //
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          labelText: "   Zip/ Postal code",
        ),
      ),
    );
  }

  Padding description() {
    return Padding(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Expanded(
            child: TextField(
                maxLines: null,
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                // expands: true,
                style: TextStyle(fontSize: 15, height: 1.3),
                decoration: InputDecoration(
                  //
                  filled: true,
                  fillColor: Colors.white,
                  // errorStyle: TextStyle(color: Colors.red),
                  // errorText: _isNotValidate ? "" : null,
                  //
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  labelText: "   Description",
                ))));
  }

  Padding country() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
      child: TextField(
        controller: countryController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 15, height: 0.7),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          // errorStyle: TextStyle(color: Colors.red),
          // errorText: _isNotValidate ? "Enter full name" : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          labelText: "   Country",
        ),
        onTap: () {},
      ),
    );
  }

  Padding city() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: TextField(
            controller: cityController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 15, height: 0.7),
            decoration: InputDecoration(
              //
              filled: true,
              fillColor: Colors.white,
              // errorStyle: TextStyle(color: Colors.red),
              // errorText: _isNotValidate ? "Enter correct city" : null,
              //
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              labelText: "   City",
            ),
            onTap: () {}));
  }

  Padding streetName() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: TextField(
          controller: streetNameController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15, height: 0.7),
          decoration: InputDecoration(
            //
            filled: true,
            fillColor: Colors.white,
            // errorStyle: TextStyle(color: Colors.red),
            // errorText: _isNotValidate ? "Enter full name" : null,
            //
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            labelText: "   Street Name",
          ),
          onTap: () {},
        ));
  }

  Padding propertyName() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: TextField(
            controller: propertyNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 15, height: 0.7),
            decoration: InputDecoration(
              //
              filled: true,
              fillColor: Colors.white,
              // errorStyle: TextStyle(color: Colors.red),
              // errorText: _isNotValidate ? "Enter full name" : null,
              //
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              labelText: "   Property Name",
            )));
  }

  Padding password() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: TextField(
            obscureText: passwordVisible,
            controller: passwordController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 15, height: 0.7),
            decoration: InputDecoration(
                //
                filled: true,
                fillColor: Colors.white,
                //
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                labelText: "   Password",
                //
                suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    }))));
  }

  Padding email() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 15, height: 0.7),
          decoration: InputDecoration(
            //
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.red),
            errorText: !validateEmail(emailController.text)
                ? "Enter valid email"
                : null,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            labelText: "   Enter mail",
          ),
        ));
  }

  Padding ownerName() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: TextField(
            cursorHeight: 20,
            controller: ownerNameController,
            keyboardType: TextInputType.text,
            //
            style: TextStyle(fontSize: 15, height: 0.7),
            decoration: InputDecoration(
              //
              filled: true,
              fillColor: Colors.white,
              // errorStyle: TextStyle(color: Colors.red),
              // errorText: _isNotValidate ? "Enter full name" : null,
              //
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              labelText: "   Owner Name",
            )));
  }

  Padding _buildCSCPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
      child: CSCPicker(
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1.7,
          ),
        ),
        disabledDropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
          color: Colors.grey.withOpacity(0.3),
          border: Border.all(
            color: Colors.grey,
            width: 1.3,
          ),
        ),
        layout: Layout.vertical,
        flagState: CountryFlag.ENABLE,
        onCountryChanged: (value) {
          setState(() {
            selectedCountry = value;
          });
        },
        onStateChanged: (value) {
          setState(() {
            selectedState = value;
          });
        },
        onCityChanged: (value) {
          setState(() {
            selectedCity = value;
          });
        },
      ),
    );
  }
}
