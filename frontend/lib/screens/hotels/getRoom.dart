import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      final roomResponse =
          await _dio.get('http://192.168.31.116:3000/hotel/rooms/$hotelId');

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
                          left: 10,
                          right: 10,
                          bottom: 5,
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
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                room.roomType,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                room.price,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              trailing: Icon(Icons.edit),
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
        floatingActionButton: FloatingActionButton(
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
          child: Icon(Icons.bookmark_border_outlined),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
        ),
      ),
    );
  }
}
