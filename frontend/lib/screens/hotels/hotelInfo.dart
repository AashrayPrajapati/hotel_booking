import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class Hotel {
  final String propertyName;
  final String streetName;
  final String city;
  final String description;
  Hotel(
    this.propertyName,
    this.streetName,
    this.city,
    this.description,
  );
}

class Room {
  final String roomType;
  final String maxCapacity;
  final String price;
  Room(
    this.roomType,
    this.maxCapacity,
    this.price,
  );
}

class HotelInfo extends StatelessWidget {
  const HotelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return HotelInfoPage();
  }
}

class HotelInfoPage extends StatefulWidget {
  const HotelInfoPage({super.key});

  @override
  State<HotelInfoPage> createState() => _HotelInfoPageState();
}

class _HotelInfoPageState extends State<HotelInfoPage> {
  final Dio _dio = Dio();

  // double _initialRating = 4.5;
  // IconData? _selectedIcon;

  Future<Hotel> getHotel(String id) async {
    try {
      final response =
          await _dio.get('http://10.0.2.2:3000/hotel/getHotel/$id');

      final roomResponse =
          await _dio.get('http://10.0.2.2:3000/hotel/rooms/$id');

      var jsonData = response.data;
      var roomData = roomResponse.data;

      print("Room Data: $roomData");
      for (var room in roomData) {
        print("Room Type: ${room['roomType']}");
      }

      Hotel hotel = Hotel(
        jsonData['propertyName'] ?? '',
        jsonData['streetName'] ?? '',
        jsonData['city'] ?? '',
        jsonData['description'] ?? '',
      );

      return hotel;
    } on DioError catch (e) {
      print(e);

      throw Exception("Error retrieving posts: ${e}");
    }
  }

  // Future<Room> getRoom(String id) async {
  //   try {
  //     final roomResponse =
  //         await _dio.get('http://10.0.2.2:3000/hotelRoom/getRooms/$id');

  //     var jsonData = roomResponse.data;
  //     print(jsonData);

  //     Room room = Room(
  //       jsonData['roomType'],
  //       jsonData['maxCapacity'],
  //       jsonData['price'],
  //     );

  //     return room;
  //   } on DioError catch (e) {
  //     throw Exception("Error retrieving posts: ${e.message}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var ID = ModalRoute.of(context)!.settings.arguments as String;
    print(ID);

    return Column(
      children: [
        Expanded(
          flex: 8,
          child: FutureBuilder(
            future: getHotel(ID),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(fontFamily: 'OpenSans'),
                  home: Scaffold(
                    appBar: AppBar(
                        title: Text(snapshot.data.propertyName),
                        centerTitle: true,
                        backgroundColor: Colors.blue[500],
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pushNamed(context, 'mainPage');
                            })),
                    body: Stack(
                      children: [
                        ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Container(
                                              child: Image.network(
                                                'https://bit.ly/3KAjXJW',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          snapshot.data
                                                              .propertyName,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: snapshot
                                                                  .data
                                                                  .streetName,
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                                text: ", "),
                                                            TextSpan(
                                                              text: snapshot
                                                                  .data.city,
                                                              style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: ShapeDecoration(
                                                      color: Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "8.7",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ReadMoreText(
                                              snapshot.data.description,
                                              textAlign: TextAlign.justify,
                                              //
                                              trimLength: 333,
                                              trimMode: TrimMode.Length,
                                              trimCollapsedText: '   Show more',
                                              trimExpandedText: '   Show less',
                                              moreStyle: TextStyle(
                                                color: Colors.blue[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              lessStyle: TextStyle(
                                                color: Colors.blue[600],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // getRoom();
                                              },
                                              child: Text(
                                                "Book Now",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // make a listview of rooms
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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
