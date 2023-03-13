import 'package:flutter/material.dart';

class HotelCrud extends StatefulWidget {
  const HotelCrud({super.key});

  @override
  State<HotelCrud> createState() => HotelCrudState();
}

class HotelCrudState extends State<HotelCrud> {
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  //
  final _propertyNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _streetNameController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    //
    _propertyNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _streetNameController.dispose();
    super.dispose();
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
                      controller: _ownerNameController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _emailController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _phoneNumberController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Phone Number",
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
                      controller: _propertyNameController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _countryController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _cityController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _postalCodeController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
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
                      controller: _streetNameController,
                      style: TextStyle(fontSize: 15, height: 0.7),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        labelText: "   Street Name",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final ownerName = _ownerNameController.text;
                      final email = _emailController.text;
                      final phoneNumber = _phoneNumberController.text;
                      final propertyName = _propertyNameController.text;
                      final country = _countryController.text;
                      final city = _cityController.text;
                      final postalCode = _postalCodeController.text;
                      final streetName = _streetNameController.text;
                      //
                      print("Owner Name: $ownerName\n");
                      print("Email: $email");
                      print("Phone Number: $phoneNumber");
                      print("Property Name: $propertyName");
                      print("Country: $country");
                      print("City: $city");
                      print("Zip/ Postal code: $postalCode");
                      print("Street Name: $streetName");

                      Navigator.pushNamed(context, 'hotelDetails');
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
