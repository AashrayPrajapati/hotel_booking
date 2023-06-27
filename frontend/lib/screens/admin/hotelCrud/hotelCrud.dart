import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:hotel_booking/config.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc_picker/csc_picker.dart';

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

  late TextEditingController ownerNameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController propertyNameController = TextEditingController();
  late TextEditingController countryController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  // late TextEditingController postalCodeController = TextEditingController();
  late TextEditingController streetNameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  bool _isNotValidate = false;

  void registerHotel() async {
    if (ownerNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        propertyNameController.text.isNotEmpty &&
        countryController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        // postalCodeController.text.isNotEmpty &&
        streetNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
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
        Navigator.pushNamed(context, 'login');
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
            backgroundColor: Color.fromARGB(255, 238, 238, 238),
            appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 39, 92, 216),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('yoHotel',
                    style: TextStyle(
                        // color: Color.fromARGB(255, 34, 150, 243),
                        fontSize: 25,
                        fontWeight: FontWeight.w600))),
            body: SingleChildScrollView(
                child: Stack(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: 20),
                Text("Create Hotel",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ownerName(),
                email(),
                password(),
                Divider(color: Colors.black38),
                propertyName(),
                country(),
                city(),
                // postalCode(),
                streetName(),
                description(),
                TextButton(
                  onPressed: () {
                    // showDialog(
                    //   // barrierDismissible: false, // user must tap button!

                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: Text("Confirm"),
                    //       content: Text(
                    //           "Are you sure you want to register with this data?"),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //           child: Text("No"),
                    //         ),
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //             Navigator.pushNamed(context, 'dashboard');
                    //           },
                    //           child: Text("Yes"),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );

                    registerHotel();
                  },
                  child: Text("Next"),
                )
              ])
            ]))));
  }

  Padding postalCode() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
        right: 15,
        left: 15,
      ),
      child: TextField(
        // controller: postalCodeController,
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
    );
  }

  Padding description() {
    return Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
          right: 15,
          left: 15,
        ),
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
                  fillColor: Colors.transparent,
                  errorStyle: TextStyle(color: Colors.white),
                  errorText: _isNotValidate ? "Enter full name" : null,
                  //
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  labelText: "   Description",
                ))));
  }

  Padding country() {
    return Padding(
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
          filled: true,
          fillColor: Colors.transparent,
          errorStyle: TextStyle(color: Colors.white),
          errorText: _isNotValidate ? "Enter full name" : null,
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
            onTap: () {}));
  }

  Padding streetName() {
    return Padding(
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
          onTap: () {},
        ));
  }

  Padding propertyName() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 3),
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
            )));
  }

  Padding password() {
    return Padding(
        padding: const EdgeInsets.only(
          bottom: 7,
          right: 15,
          left: 15,
        ),
        child: TextField(
            obscureText: passwordVisible,
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
            )));
  }

  Padding ownerName() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: TextField(
            cursorHeight: 20,
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
            )));
  }
}
