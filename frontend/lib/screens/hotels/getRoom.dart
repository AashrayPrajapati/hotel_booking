import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/screens/admin/roomCrud/createRoom.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GetRooms extends StatefulWidget {
  const GetRooms({Key? key}) : super(key: key);

  @override
  State<GetRooms> createState() => _GetRoomsState();
}

class Room {
  final String roomType;
  final String maxCapacity;
  final String price;
  final String id;

  Room({
    required this.roomType,
    required this.maxCapacity,
    required this.price,
    required this.id,
  });
}

class _GetRoomsState extends State<GetRooms> {
  final Dio _dio = Dio();

  String ownerId = '';

  Future<void> jwtDecode() async {
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
    setState(() {
      ownerId = payloadJson['_id'];
    });

    print('UPDATE ROOM PAGE');
    print('Stored Role: $userRole');
    print('USER ID: $ownerId');
  }

  @override
  void initState() {
    super.initState();
    jwtDecode();
  }

  Future<List<Room>> getRooms(String hotelId) async {
    try {
      List<Room> rooms = [];
      final roomResponse = await _dio.get('$apiUrl/hotel/rooms/$hotelId');

      var roomData = roomResponse.data;

      for (var data in roomData) {
        Room room = Room(
          roomType: data['roomType'],
          maxCapacity: data['maxCapacity'],
          price: data['price'],
          id: data['_id'],
        );
        rooms.add(room);
        print(rooms);
      }
      return rooms;
    } on DioError catch (e) {
      throw Exception("Error retrieving rooms: ${e.message}");
    }
  }

  Future<ParseObject?> fetchImage(String roomId) async {
    QueryBuilder<ParseObject> queryBook = QueryBuilder<ParseObject>(parseObject)
      ..whereEqualTo('roomId', roomId)
      ..whereEqualTo('ownerId', ownerId);

    final ParseResponse responseBook = await queryBook.query();

    if (responseBook.success && responseBook.results != null) {
      return (responseBook.results?.first) as ParseObject;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> arguments =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final String? hotelId = arguments['id'] as String?;

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
            //replace with our own icon data.
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
        body: FutureBuilder<List<Room>>(
          future: getRooms(ownerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Room> rooms = snapshot.data ?? [];

              if (rooms.isEmpty) {
                return Center(child: Text('No rooms available.'));
              }

              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  Room room = rooms[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(
                              'updateRoom',
                              arguments: {
                                'id': room.id,
                                'roomType': room.roomType,
                                'maxCapacity': room.maxCapacity,
                                'price': room.price,
                              },
                            );
                          },
                          child: Card(
                            color: Color.fromARGB(255, 76, 120, 223),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 13,
                                right: 13,
                                top: 7,
                                bottom: 7,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                    future: fetchImage(room.id),
                                    builder: ((context, snapshot) {
                                      var varFile = snapshot.data
                                          ?.get<ParseFileBase>('file');
                                      print('.....${varFile?.url ?? 'hell'}');
                                      if (varFile?.url?.isEmpty ?? true) {
                                        return Image.network(
                                          'https://picsum.photos/200/300/?blur',
                                          width: 100,
                                          height: 100,
                                        );
                                      }
                                      return Image.network(
                                        varFile?.url ?? "",
                                        width: 100,
                                        height: 100,
                                      );
                                    }),
                                  ),

                                  // if there is image, display here
                                  // else display default image

                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        room.roomType,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      subtitle: Text(
                                        room.price,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.edit,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Add your desired functionality here
                  print('Floating action button pressed');
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    'viewBooking',
                    arguments: {
                      'id': ownerId,
                    },
                  );
                },
                child: Icon(Icons.edit_calendar_outlined, size: 27),
                backgroundColor: Color.fromARGB(255, 39, 92, 216),
              ),
              SizedBox(
                height: 10,
              ),
              Text('View Bookings',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
