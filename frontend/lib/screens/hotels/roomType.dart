import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class RoomType extends StatelessWidget {
  const RoomType({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomTypePage();
  }
}

class RoomTypePage extends StatefulWidget {
  const RoomTypePage({super.key});

  @override
  State<RoomTypePage> createState() => _RoomTypePageState();
}

class _RoomTypePageState extends State<RoomTypePage> {
  final Dio _dio = Dio();

  double _initialRating = 4.5;
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    var ID = ModalRoute.of(context)!.settings.arguments as String;
    print(ID);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hotel Info Page"),
          centerTitle: true,
          backgroundColor: Colors.blue[500],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 1,
                          child: FutureBuilder(
                            future: getHotel(ID),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data.propertyName,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: snapshot
                                                              .data.streetName,
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                        TextSpan(text: ", "),
                                                        TextSpan(
                                                          text: snapshot
                                                              .data.city,
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating:
                                                        _initialRating,
                                                    minRating: 1,
                                                    allowHalfRating: true,
                                                    unratedColor: Colors.amber
                                                        .withAlpha(70),
                                                    itemCount: 5,
                                                    itemSize: 20.0,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      _selectedIcon ??
                                                          Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      setState(() {
                                                        // _rating = rating;
                                                      });
                                                    },
                                                    updateOnDrag: true,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: ShapeDecoration(
                                                  color: Colors.blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                        Divider(),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        // ElevatedButton(
                                        //   style: ElevatedButton.styleFrom(
                                        //     primary: Colors.teal[400],
                                        //   ),
                                        //   onPressed: () {
                                        //     // var ID = snapshot.data[index]._id;
                                        //     // Navigator.of(context,
                                        //     //         rootNavigator: true)
                                        //     //     .pushNamed(
                                        //     //   'roomType',
                                        //     //   arguments: ID,
                                        //     // );
                                        //   },
                                        //   child: Text('Select room type'),
                                        // ),
                                        GestureDetector(
                                          onTap: () {
                                            var ID = snapshot.data[index]._id;
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushNamed(
                                              'roomType',
                                              arguments: ID,
                                            );
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .8,
                                            child: Text('Select room types'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Hotel> getHotel(String id) async {
    try {
      // final response =
      // await _dio.get('http://100.22.8.195:3000/users/'); //college
      final response =
          // await _dio.get('http://10.0.2.2:3000/hotel/getHotels/$id');
          await _dio.get('http://192.168.31.116:3000/hotel/getHotels/$id');

      var jsonData = response.data;

      Hotel hotel = Hotel(
        jsonData['propertyName'],
        jsonData['streetName'],
        jsonData['city'],
        jsonData['description'],
      );

      return hotel;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }
}

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
