import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/utils.dart';
import 'package:intl/intl.dart';
// import 'package:get/get.dart';
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

var hId;

class Room {
  final String roomType;
  final String maxCapacity;
  final String price;
  final String _id;
  Room(this.roomType, this.maxCapacity, this.price, this._id);
}

class HotelInfo extends StatelessWidget {
  const HotelInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return HotelInfoPage();
  }
}

Future postComment() async {
  try {
    var regBody = {
      'user': ownerId, //ownerId is userId
      'hotelId': hId,
      'comment': commentController.text
    };
    print('azwsxerdtcfvgybzsxrdtcfgvybhjnsxrfvtgbyhujnsxtcrfvgyhuj');
    print(ownerId);
    print(regBody);

    final response = await Dio().post(
      '$apiUrl/comment/post',
      options:
          Options(headers: {'Content-Type': 'application/json; charset=UTF-8'}),
      data: regBody,
    );
    print(response.data);
    commentController.clear();
  } on DioError catch (e) {
    print(e);
  }
}

class Comment {
  final String userName;
  final String comment;
  final String timestamp;

  Comment(this.userName, this.comment, this.timestamp);

  @override
  String toString() {
    return 'User: $userName, Comment: $comment';
  }
}

Future<List<Comment>> getComments() async {
  try {
    print(hId);
    List<Comment> comments = [];
    final commentResponse = await Dio().get('$apiUrl/comment/getComment/$hId');

    var commentData = commentResponse.data;

    for (var data in commentData) {
      Comment comment = Comment(
        data['userName'],
        data['comment'],
        DateFormat('yyyy-MM-dd').format(DateTime.parse(data['timestamp'])),
      );
      comments.add(comment);
    }
    print(comments);
    return comments;
  } on DioError catch (e) {
    throw Exception("Error retrieving comments: ${e.message}");
  }
}

final Dio _dio = Dio();
TextEditingController commentController = TextEditingController();

class HotelInfoPage extends StatefulWidget {
  const HotelInfoPage({super.key});

  @override
  State<HotelInfoPage> createState() => _HotelInfoPageState();
}

class _HotelInfoPageState extends State<HotelInfoPage> {
  @override
  void initState() {
    super.initState();
    decodeUser();
  }

  // double _initialRating = 4.5;
  // IconData? _selectedIcon;

  Future<Hotel> getHotel(String id, String userId, String nights,
      String startDate, String endDate) async {
    try {
      print('HotelInfoPage');
      print('number of night: $nights');
      print('check-in date: $startDate');
      print('check-out date: $endDate');
      print('user ID: $userId');
      // print('````````````````````````````````````````````');

      final response = await _dio.get('$apiUrl/hotel/getHotel/$id');

      var jsonData = response.data;

      Hotel hotel = Hotel(
          jsonData['propertyName'] ?? '',
          jsonData['streetName'] ?? '',
          jsonData['city'] ?? '',
          jsonData['description'] ?? '');

      return hotel;
    } on DioError catch (e) {
      print(e);

      throw Exception("Error retrieving posts: ${e}");
    }
  }

  Future<List<Room>> getRoom(String roomID) async {
    try {
      List<Room> rooms = [];
      final roomResponse = await _dio.get('$apiUrl/hotel/rooms/$roomID');

      var roomData = roomResponse.data;

      for (var data in roomData) {
        Room room = Room(
            data['roomType'], data['maxCapacity'], data['price'], data['_id']);
        rooms.add(room);
      }
      return rooms;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final String? price = arguments['price'] as String?;
    final String? HotelID = arguments['id'] as String?;

    hId = HotelID;
    final String? userId = arguments['userId'] as String?;
    final String? numberOfNights = arguments['numberOfNights'] as String?;
    final String? startDate = arguments['startDate'] as String?;
    final String? endDate = arguments['endDate'] as String?;

    return Column(children: [
      Expanded(
          flex: 3,
          child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                getHotel(
                    HotelID!, userId!, numberOfNights!, startDate!, endDate!),
                getRoom(HotelID)
              ]),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final hotelData = snapshot.data![0] as Hotel;
                  final roomData = snapshot.data![1] as List<Room>;
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                          backgroundColor: Color.fromARGB(255, 238, 238, 238),
                          extendBodyBehindAppBar: true,
                          appBar: AppBar(
                              elevation: 0,
                              title: Text(hotelData.propertyName,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600)),
                              centerTitle: true,
                              backgroundColor: Color.fromARGB(255, 39, 92, 216),
                              leading: IconButton(
                                  icon: Icon(Icons.arrow_back_ios_new,
                                      color:
                                          Color.fromARGB(255, 238, 241, 252)),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'mainPage');
                                  })),
                          body: Stack(children: [
                            ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return SingleChildScrollView(
                                      child: Stack(children: [
                                    Column(children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                  'https://bit.ly/3KAjXJW',
                                                  height: 250,
                                                  fit: BoxFit.cover))),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          flex: 8,
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    hotelData
                                                                        .propertyName,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 7),
                                                                Text(
                                                                    hotelData
                                                                            .streetName +
                                                                        ', ' +
                                                                        hotelData
                                                                            .city,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            15,
                                                                        fontStyle:
                                                                            FontStyle.italic)),
                                                                SizedBox(
                                                                    height: 10)
                                                              ])),

                                                      Expanded(
                                                          flex: 2,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 20,
                                                                      bottom:
                                                                          20),
                                                              child: SizedBox(
                                                                  width: 30,
                                                                  child:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            // getComments();
                                                                            // print(ownerId);
                                                                            showModalBottomSheet(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return commentSection();
                                                                                });
                                                                          },
                                                                          icon: Icon(
                                                                              Icons.comment_outlined,
                                                                              color: Color.fromARGB(255, 39, 92, 216),
                                                                              size: 30))))),

                                                      //THIS IS FOR RATING---------------
                                                      // Container(
                                                      //     padding:
                                                      //         EdgeInsets.all(5),
                                                      //     decoration: ShapeDecoration(
                                                      //         color:
                                                      //             Colors.blue,
                                                      //         shape: RoundedRectangleBorder(
                                                      //             borderRadius:
                                                      //                 BorderRadius.circular(
                                                      //                     10),
                                                      //             side: BorderSide(
                                                      //                 color: Color.fromARGB(
                                                      //                     255,
                                                      //                     0,
                                                      //                     0,
                                                      //                     0)))),
                                                      //     child: Center(
                                                      //         child: Text("8.7",
                                                      //             style: TextStyle(
                                                      //                 color: Colors.white,
                                                      //                 fontWeight: FontWeight.bold))))
                                                    ])),
                                            ReadMoreText(hotelData.description,
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                                textAlign: TextAlign.justify,
                                                //
                                                trimLength: 333,
                                                trimMode: TrimMode.Length,
                                                trimCollapsedText:
                                                    '   Show more',
                                                trimExpandedText:
                                                    '   Show less',
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
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  var room = roomData[
                                                      index]; // Get the room at the tapped index
                                                  var ID = room._id;
                                                  var price = room.price;
                                                  var roomName = room.roomType;

                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pushNamed('booking',
                                                          arguments: {
                                                        'userId': userId,
                                                        'roomName':
                                                            roomName.toString(),
                                                        'hotelId':
                                                            HotelID.toString(),
                                                        'roomId': ID,
                                                        'startDate': startDate
                                                            .toString(),
                                                        'endDate':
                                                            endDate.toString(),
                                                        'numberOfNights':
                                                            numberOfNights
                                                                .toString(),
                                                        'price': price
                                                      });

                                                  print('Hotel ID: $HotelID');
                                                  print(
                                                      'Hotel room name: $roomName');
                                                  print('Room ID: $ID');
                                                  print(
                                                      'Check-in date: $startDate');
                                                  print(
                                                      'Check-out date: $endDate');
                                                  print(
                                                      'This is the numberOfNights: $numberOfNights');
                                                  print(
                                                      'This is the price: $price');
                                                },
                                                child: Column(
                                                    children:
                                                        roomData.map((room) {
                                                  var roomIndex = roomData.indexOf(
                                                      room); // Get the index of the current room
                                                  return Column(children: [
                                                    Card(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    17)),
                                                        elevation: 7,
                                                        child: ListTile(
                                                            title: Text(
                                                                room.roomType,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18)),
                                                            subtitle: Text(
                                                                room.price,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15)),
                                                            trailing: Icon(
                                                                color: Colors
                                                                    .black,
                                                                Icons.arrow_forward_ios,
                                                                size: 15),
                                                            onTap: () {
                                                              var selectedRoom =
                                                                  roomData[
                                                                      roomIndex]; // Get the selected room based on the index
                                                              var ID =
                                                                  selectedRoom
                                                                      ._id;
                                                              var price =
                                                                  selectedRoom
                                                                      .price;
                                                              var roomName =
                                                                  selectedRoom
                                                                      .roomType;

                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pushNamed(
                                                                      'booking',
                                                                      arguments: {
                                                                    'userId':
                                                                        userId,
                                                                    'roomName':
                                                                        roomName
                                                                            .toString(),
                                                                    'hotelId':
                                                                        HotelID
                                                                            .toString(),
                                                                    'roomId':
                                                                        ID,
                                                                    'startDate':
                                                                        startDate
                                                                            .toString(),
                                                                    'endDate':
                                                                        endDate
                                                                            .toString(),
                                                                    'numberOfNights':
                                                                        numberOfNights
                                                                            .toString(),
                                                                    'price':
                                                                        price
                                                                  });

                                                              print(
                                                                  'Hotel ID: $HotelID');
                                                              print(
                                                                  'Hotel room name: $roomName');
                                                              print(
                                                                  'Room ID: $ID');
                                                              print(
                                                                  'Check-in date: $startDate');
                                                              print(
                                                                  'Check-out date: $endDate');
                                                              print(
                                                                  'This is the numberOfNights: $numberOfNights');
                                                              print(
                                                                  'This is the price: $price');
                                                            })),
                                                    SizedBox(height: 10)
                                                  ]);
                                                }).toList()))
                                          ]))
                                    ])
                                  ]));
                                })
                          ])));
                }
              }))
    ]);
  }

  List<Map<String, dynamic>> comments = [
    {
      "userNmae": 'John Doe',
      "hotelId": 101,
      "comment": "Great hotel with excellent service!"
    },
    {
      "userNmae": 'Doe Doe',
      "hotelId": 102,
      "comment": "The room was clean and comfortable."
    },
    {
      "userNmae": 'John John',
      "hotelId": 103,
      "comment": "I had a pleasant stay at this hotel."
    }
  ];

  Container commentSection() {
    return Container(
        height: 500,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                Expanded(
                    child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  postComment();
                                },
                                icon: Icon(Icons.send,
                                    color: Color.fromARGB(255, 39, 92, 216))),
                            hintText: 'Add a comment',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)))))
              ])),
          SizedBox(height: 15),
          Text('Reviews',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  decoration: TextDecoration.underline)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<List<Comment>>(
              future: getComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Data has been successfully fetched
                  List<Comment> comments = snapshot.data ?? [];
                  if (comments.isEmpty) {
                    return Center(child: Text('No comments available'));
                  }
                  return Row(
                    children: List.generate(comments.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(23),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ProfilePicture(
                                      name: comments[index].userName,
                                      radius: 31,
                                      fontsize: 21,
                                      random: true,
                                    ),
                                    SizedBox(width: 23),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          comments[index].userName,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 38, 38, 38),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          comments[index].timestamp,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                    255, 107, 107, 107)
                                                .withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 23),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: ReadMoreText(comments[index].comment,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        textAlign: TextAlign.justify,
                                        //
                                        trimLength: 200,
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
                                            fontStyle: FontStyle.italic)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ),
        ]));
  }
}
