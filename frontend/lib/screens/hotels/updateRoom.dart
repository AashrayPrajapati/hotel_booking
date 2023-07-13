import 'package:flutter/material.dart';

// import 'package:hotel_booking/screens/hotels/getRoom.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hotel_booking/config.dart';

class UpdateRoom extends StatefulWidget {
  const UpdateRoom({Key? key}) : super(key: key);

  @override
  State<UpdateRoom> createState() => UpdateRoomState();
}

class UpdateRoomState extends State<UpdateRoom> {
  final Dio _dio = Dio();

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

    final String url = "$apiUrl/hotelRoom/updateRoom/$roomId";

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
      //
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Room Updated',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  content: Text('Room Updated Successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17)),
                  actions: [
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'getRooms');
                            },
                            child: Text('OK')))
                  ]));
    } else {
      print('Room Not Updated');
      //
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Room Not Updated',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  content: Text('The room was not updated',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17)),
                  actions: [
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK')))
                  ]));
    }
  }

  void deleteRoom(String roomId) async {
    final String roomType = roomTypeController.text;
    final String capacity = capacityController.text;
    final String price = priceController.text;

    final String url = "$apiUrl/hotelRoom/deleteRoom/$roomId";

    final response = await _dio.delete(url, data: {
      "roomType": roomType,
      "maxCapacity": capacity,
      "price": price
      // "description": description,
    });

    print(response.data);

    if (response.statusCode == 200) {
      print('Room Deleted');
      //
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text('Room Deleted',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  content: Text('Room deleted successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17)),
                  actions: [
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'mainPage');
                            },
                            child: Text('OK')))
                  ]));
    } else {
      print('Room Not Deleted');
      //
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Room Not Deleted',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  content: Text('The room was not deleted',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17)),
                  actions: [
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK')))
                  ]));
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
            backgroundColor: Color.fromARGB(255, 232, 232, 232),
            appBar: AppBar(
                elevation: 3,
                backgroundColor: Color.fromARGB(255, 39, 92, 216),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'mainPage');
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                title: Text('Rooms',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                centerTitle: true),
            body: Center(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 7,
                            child: Column(children: [
                              // Padding(
                              //     padding: const EdgeInsets.only(
                              //         top: 20, bottom: 10),
                              //     child: Text('Update Room',
                              //         style: TextStyle(
                              //             fontSize: 20,
                              //             fontWeight: FontWeight.bold))),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10, left: 20, right: 20),
                                  child: TextField(
                                      controller: roomTypeController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          labelText: 'Room Type'))),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-5]'))
                                      ],
                                      controller: capacityController,
                                      decoration: InputDecoration(
                                          labelText: 'Max. capacity',
                                          hintText: '5',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(17))))),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 20, right: 20),
                                  child: TextField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.,]'))
                                      ],
                                      //
                                      controller: priceController,
                                      decoration: InputDecoration(
                                          labelText: 'Price',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(17))))),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              updateRoom(roomId!);
                                              print(roomTypeController.text);
                                              print(capacityController.text);
                                              print(priceController.text);

                                              // Navigator.pushNamed(context, 'mainPage');
                                            },
                                            child: Text('Update',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 39, 92, 216),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            17)),
                                                minimumSize: Size(150, 50)))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 20,
                                        ),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          title: Text('Alert!',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 23,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          content: Text(
                                                              'Are you sure you want to delete this room?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17)),
                                                          actions: [
                                                            Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        deleteRoom(
                                                                            roomId!);
                                                                      },
                                                                      child: Text(
                                                                          'Yes')),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'No')),
                                                                ],
                                                              ),
                                                            )
                                                          ]));
                                              // deleteRoom(roomId!);
                                              //

                                              // print(roomTypeController.text);
                                              // print(capacityController.text);
                                              // print(priceController.text);

                                              // Navigator.pushNamed(context, 'mainPage');
                                            },
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 179, 65, 65),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                ),
                                                minimumSize: Size(150, 50))))
                                  ])
                            ])))))));
  }
}
