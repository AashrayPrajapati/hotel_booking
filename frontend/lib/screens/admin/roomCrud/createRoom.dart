// ignore_for_file: unused_field

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomCreate extends StatelessWidget {
  const RoomCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomCreatePage();
  }
}

class RoomCreatePage extends StatefulWidget {
  const RoomCreatePage({super.key});

  @override
  State<RoomCreatePage> createState() => _RoomCreatePageState();
}

class _RoomCreatePageState extends State<RoomCreatePage> {
  File? _image;
  String ownerId = '';

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
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

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  String roomTypeValue = 'Single Bed';

  var number = ['Single Bed', 'Double Bed'];

  TextEditingController priceController = TextEditingController();
  TextEditingController maxGuestCapacityController = TextEditingController();
  bool _isNotValidate = false;

  @override
  void dispose() {
    priceController.dispose();
    maxGuestCapacityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    jwtDecode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(ownerId);
    void room() async {
      if (roomTypeValue.isNotEmpty &&
          priceController.text.isNotEmpty &&
          maxGuestCapacityController.text.isNotEmpty) {
        var regBody = {
          "hotelId": ownerId,
          "roomType": roomTypeValue,
          "price": priceController.text,
          "maxCapacity": maxGuestCapacityController.text,
        };
        print(regBody);
        try {
          final Dio _dio = Dio();

          var response = await _dio.post(
            // 'http://10.0.2.2:3000/hotelRoom/register',
            'http://192.168.31.116:3000/hotelRoom/register',
            options: Options(headers: {"Content-Type": "application/json"}),
            data: jsonEncode(regBody),
          );
          Navigator.of(context, rootNavigator: true).pushNamed('mainPage');

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

    //
    // hotelRomm/register
    return MaterialApp(
      debugShowCheckedModeBanner: false,
// theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
            //replace with our own icon data.
          ),
          title: Text(
            'yoHotel',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 17, left: 17, right: 17),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add new room',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        bottom: 15,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What type of room would you like to add?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Container(
                              color: Colors.white,
                              child: DropdownButton(
                                underline: Container(
                                  height: 1,
                                  color: Colors.black,
                                ),

                                // Initial Value
                                value: roomTypeValue,

                                // Down Arrow Icon
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),

                                // Array list of items
                                items: number.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                    ),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    roomTypeValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            'What is the price per Night for this room?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  hintText: 'Price',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'What is the maximum number of guests allowed in the room?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: maxGuestCapacityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  hintText: '3',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Upload a photo of the room:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : Placeholder(
                                    color: Colors.grey,
                                    fallbackHeight: 180,
                                  ),
                          ),
                          CustomButton(
                            title: 'Pick from Gallery',
                            icon: Icons.image,
                            onClick: () => getImage(ImageSource.gallery),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                room();
                                // if (_isNotValidate == true) {
                                //   Navigator.pushNamed(context, 'mainPage');
                                // }
                              },
                              child: Text('Submit'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 170,
    child: ElevatedButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 20),
          Text("Pick an image"),
        ],
      ),
    ),
  );
}
