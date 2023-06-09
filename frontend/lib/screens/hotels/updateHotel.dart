import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateHotel extends StatefulWidget {
  const UpdateHotel({Key? key});

  @override
  State<UpdateHotel> createState() => _UpdateHotelState();
}

class Hotel {
  final String propertyName;
  final String ownerName;
  final String email;
  final String streetName;
  final String city;
  final String description;
  final String password;
  final String country;

  Hotel(
    this.propertyName,
    this.ownerName,
    this.email,
    this.streetName,
    this.city,
    this.description,
    this.password,
    this.country,
  );
}

final Dio _dio = Dio();

Future<Hotel> getHotel(String id) async {
  try {
    final response = await _dio.get('http://10.0.2.2:3000/hotel/getHotel/$id');

    var jsonData = response.data;

    Hotel hotel = Hotel(
      jsonData['propertyName'] ?? '',
      jsonData['ownerName'] ?? '',
      jsonData['email'] ?? '',
      jsonData['streetName'] ?? '',
      jsonData['city'] ?? '',
      jsonData['description'] ?? '',
      jsonData['password'] ?? '',
      jsonData['country'] ?? '',
    );

    return hotel;
  } on DioError catch (e) {
    print(e);
    throw Exception("Error retrieving posts: ${e.response}");
  }
}

class _UpdateHotelState extends State<UpdateHotel> {
  TextEditingController propertyNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void updateHotel(
      String hotelId,
      String ownerName,
      String email,
      String description,
      String propertyName,
      String country,
      String city,
      String streetName,
      String password) async {
    final String url = "http://10.0.2.2:3000/hotel/getHotel/$hotelId";

    final response = await _dio.patch(
      url,
      data: {
        // "roomType": roomType,
        // "maxCapacity": capacity,
        // "price": price,
        // "description": description,
        "ownerName": ownerName,
        "email": email,
        "password": password,
        "propertyName": propertyName,
        "country": country,
        "city": city,
        "postalCode": "44800",
        "streetName": streetName,
        "description": description,
      },
    );

    print(response.data);
    if (response.statusCode == 200) {
      print('Hotel Updated');
      // Navigator.pushNamed(context, 'user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Hotel Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Hotel Updated Successfully',
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
      print('Error updating hotel');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Hotel Not Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Hotel is not updated',
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

  void deleteHotel(
      String hotelId,
      String ownerName,
      String email,
      String description,
      String propertyName,
      String country,
      String city,
      String streetName,
      String password) async {
    final String url = "http://10.0.2.2:3000/hotel/deleteHotel/$hotelId";

    final response = await _dio.delete(
      url,
      data: {
        "ownerName": ownerName,
        "email": email,
        "password": password,
        "propertyName": propertyName,
        "country": country,
        "city": city,
        "postalCode": "44800",
        "streetName": streetName,
        "description": description,
      },
    );

    print(response.data);
    if (response.statusCode == 200) {
      print('Hotel Deleted');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Hotel Deleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Hotel Deleted Successfully',
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
      print('Error deleting hotel');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Hotel Not Deleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Hotel is not deleted',
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

  @override
  void dispose() {
    ownerNameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    propertyNameController.dispose();
    countryController.dispose();
    cityController.dispose();
    streetNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool _obscureText = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? hotelId = arguments['id'] as String?;

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              getHotel(hotelId!),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                final hotelData = snapshot.data![0] as Hotel;

                print(hotelData.ownerName);
                print(hotelData.email);
                print(hotelData.description);
                print(hotelData.propertyName);
                print(hotelData.country);
                print(hotelData.streetName);
                print(hotelData.city);
                print(hotelData.password);

                ownerNameController.text = hotelData.ownerName;
                emailController.text = hotelData.email;
                descriptionController.text = hotelData.description;
                propertyNameController.text = hotelData.propertyName;
                countryController.text = hotelData.country;
                cityController.text = hotelData.city;
                streetNameController.text = hotelData.streetName;
                passwordController.text = hotelData.password;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      backgroundColor: Color.fromARGB(255, 39, 92, 216),
                      title: Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    body: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 7,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //     top: 10,
                                //     bottom: 10,
                                //   ),
                                //   child: Center(
                                //     child: CircleAvatar(
                                //       radius: 50,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Email',
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: ownerNameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Owner Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: propertyNameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Property Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: countryController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Country',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: cityController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'City',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: streetNameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Street Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Password',
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
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    obscureText: _obscureText2,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Confirm Password',
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
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 20,
                                  ),
                                  child: TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      labelText: 'Description',
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                  ),
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        print('Update button pressed');
                                        print(ownerNameController.text);

                                        updateHotel(
                                          hotelId,
                                          ownerNameController.text,
                                          emailController.text,
                                          descriptionController.text,
                                          propertyNameController.text,
                                          countryController.text,
                                          cityController.text,
                                          streetNameController.text,
                                          passwordController.text,
                                        );
                                      },
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 39, 92, 216),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        minimumSize: Size(130, 50),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print('Delete button pressed');
                                        print(ownerNameController.text);

                                        deleteHotel(
                                          hotelId,
                                          ownerNameController.text,
                                          emailController.text,
                                          descriptionController.text,
                                          propertyNameController.text,
                                          countryController.text,
                                          cityController.text,
                                          streetNameController.text,
                                          passwordController.text,
                                        );
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 200, 62, 57),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        minimumSize: Size(130, 50),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
