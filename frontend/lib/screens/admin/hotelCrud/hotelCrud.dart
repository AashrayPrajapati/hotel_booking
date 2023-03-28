import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class HotelCrud extends StatefulWidget {
  const HotelCrud({super.key});
  @override
  State<HotelCrud> createState() => HotelCrudState();
}

class HotelCrudState extends State<HotelCrud> {
  final Dio _dio = Dio();

  TextEditingController ownerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController propertyNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  bool _isNotValidate = false;

  @override
  void dispose() {
    ownerNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    propertyNameController.dispose();
    countryController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    streetNameController.dispose();
    super.dispose();
  }

  void registerHotel() async {
    if (ownerNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        propertyNameController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        postalCodeController.text.isNotEmpty &&
        streetNameController.text.isNotEmpty) {
      var regBody = {
        "ownerName": ownerNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "propertyName": propertyNameController.text,
        "country": countryController.text,
        "city": cityController.text,
        "postalCode": postalCodeController.text,
        "streetName": streetNameController.text
      };
      print(regBody);
      try {
        var response = await _dio.post(
          'http://10.0.2.2:3000/admin/',
          options: Options(headers: {"Content-Type": "application/json"}),
          data: jsonEncode(regBody),
        );
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.data}');
      } on DioError catch (e) {
        print('Error connecting to server: ${e.message}');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'yoHotel',
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "List Hotels",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    // padding: const EdgeInsets.only(
                    //   left: 15,
                    //   right: 15,
                    //   bottom: 15,
                    // ),
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: ownerNameController,
                      keyboardType: TextInputType.text,
                      //
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Owner Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Enter mail",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter password" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Password",
                      ),
                    ),
                  ),
                  Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    // padding: const EdgeInsets.only(
                    //   bottom: 15,
                    //   right: 15,
                    //   left: 15,
                    // ),
                    child: TextField(
                      controller: propertyNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Property Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Country",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: cityController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   City",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: postalCodeController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Zip/ Postal code",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: TextField(
                      controller: streetNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        //
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Enter full name" : null,
                        //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Street Name",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // final ownerName = ownerNameController.text;
                      // final email = emailController.text;
                      // final phoneNumber = phoneNumberController.text;
                      // final propertyName = propertyNameController.text;
                      // final country = countryController.text;
                      // final city = cityController.text;
                      // final postalCode = postalCodeController.text;
                      // final streetName = streetNameController.text;
                      // //
                      // print("Owner Name: $ownerName\n");
                      // print("Email: $email");
                      // print("Phone Number: $phoneNumber");
                      // print("Property Name: $propertyName");
                      // print("Country: $country");
                      // print("City: $city");
                      // print("Zip/ Postal code: $postalCode");
                      // print("Street Name: $streetName");

                      // Navigator.pushNamed(context, 'hotelDetails');

                      registerHotel();
                    },
                    child: Text("Next"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
