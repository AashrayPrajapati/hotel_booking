import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hotel_booking/config.dart';
// import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

final parseObject = ParseObject('Gallery');
var roomID = "";

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
  String ownerId = '';

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

  String roomTypeValue = 'Single Bed';

  var number = ['Single Bed', 'Double Bed'];

  TextEditingController priceController = TextEditingController();
  TextEditingController maxGuestCapacityController = TextEditingController();
  // ignore: unused_field
  bool _isNotValidate = false;

  //
  File? _selectedImage = null;
  Dio _dio = Dio();

  Future<void> _uploadImage() async {
    ParseFileBase? parseFile;

    if (_selectedImage == null) {
      return;
    }

    try {
      parseFile = ParseFile(File(_selectedImage!.path));
      //Flutter Mobile/Desktop
      await parseFile.save();
      // roomid:'q';

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(_selectedImage?.path ?? ''),
      });

      var response = await _dio.post(
        '$apiUrl/hotelRoom/upload',
        data: formData,
      );
      print('...####' + response.toString());
      print('this is from room ID aqwsedrftugyihuoij');
      print(roomID);
      if (response.statusCode == 200) {
        final gallery = parseObject
          ..set('file', parseFile)
          ..set('ownerId', ownerId)
          ..set('roomId', roomID);
        await gallery.save();
        print('Image uploaded successfully');
        // Perform any additional actions after successful upload
      } else {
        print('Failed to upload image. Error code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred during image upload: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      await _uploadImage(); // Call the upload function after image selection
    }
  }

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
          "image": _selectedImage?.path ?? '',
        };
        print(regBody);
        try {
          final Dio _dio = Dio();

          var response = await _dio.post(
            '$apiUrl/hotelRoom/register',
            options: Options(headers: {"Content-Type": "application/json"}),
            data: jsonEncode(regBody),
          );
          Navigator.of(context, rootNavigator: true).pushNamed('mainPage');
          print(
              'qwertyuiopasdfghjklzxcvbnmasdfghjhgfdsadfghgfdfghgfdfghgfdfghgfdfghgfdttyufgvblfgv');
          roomID = response.data;
          print(roomID);
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
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What type of room would you like to add?',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 11),
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
                                      style: TextStyle(fontSize: 17),
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
                          SizedBox(height: 13),
                          Text(
                            'What is the price per Night for this room?',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 11),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.,]')),
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
                          SizedBox(height: 13),
                          Text(
                            'What is the maximum number of guests allowed in the room?',
                            style: TextStyle(
                              fontSize: 17,
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-5]'),
                                  ),
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
                          // for image
                          Text(
                            'Upload a photo of the room:',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 11),
                          _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  height: 170,
                                )
                              : Placeholder(
                                  fallbackHeight: 170,
                                ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              child: Text('Pick an desired image'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(123, 37),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 23),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                room();
                                // if (_isNotValidate == true) {
                                //   Navigator.pushNamed(context, 'mainPage');
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 39, 92, 216),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: Size(100, 50),
                              ),
                              child: Text('Submit',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  )),
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
