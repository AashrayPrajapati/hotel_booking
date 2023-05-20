import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/hotels/getRoom.dart';
// dio
import 'package:dio/dio.dart';

class UpdateRoom extends StatefulWidget {
  const UpdateRoom({Key? key}) : super(key: key);

  @override
  State<UpdateRoom> createState() => UpdateRoomState();
}

class UpdateRoomState extends State<UpdateRoom> {
  final Dio _dio = Dio();

  // i want to retireve the data from the database and show it here in the text fields so that the user can update the data and save it.

  TextEditingController roomTypeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController capacityController = TextEditingController();

  @override
  void dispose() {
    roomTypeController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    capacityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void updateRoom(String roomId) async {
    final String roomType = roomTypeController.text;
    final String capacity = capacityController.text;
    final String price = priceController.text;

    final String url =
        "http://192.168.31.116:3000/hotelRoom/updateRoom/$roomId";

    final response = await _dio.patch(
      url,
      data: {
        "roomType": roomType,
        "maxCapacity": capacity,
        "price": price,
        // "description": description,
      },
    );

    print(response.data);

    if (response.statusCode == 200) {
      print('Room Updated');
      Navigator.pushNamed(context, 'getRooms');
    } else {
      print('Room Not Updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final String? price = arguments['price'] as String?;
    final String? roomId = arguments['id'] as String?;
    final String? roomType = arguments['roomType'] as String?;
    final String? maxCapacity = arguments['maxCapacity'] as String?;
    final String? price = arguments['price'] as String?;
    print(roomId);

    // Set default values for the text fields
    roomTypeController.text = roomType ?? '';
    capacityController.text = maxCapacity ?? '';
    priceController.text = price ?? '';
    // print("object");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          title: Text(
            'Rooms',
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
              padding: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 7,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      child: Text(
                        'Update Room',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: TextField(
                        controller: roomTypeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Room Type',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: TextField(
                        controller: capacityController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Capacity',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Price',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          updateRoom(roomId!);
                          print(roomTypeController.text);
                          print(capacityController.text);
                          print(priceController.text);

                          // Navigator.pushNamed(context, 'mainPage');
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 92, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                      ),
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
}
