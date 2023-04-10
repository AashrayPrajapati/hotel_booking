import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

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

  String dropdownValue = list.first;

  double _initialRating = 4.5;
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    var ID = ModalRoute.of(context)!.settings.arguments as String;
    print(ID);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
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
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1,
                      child: FutureBuilder(
                        future: getHotel(ID),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                                        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/194624742.jpg?k=12804e9c2e1f8764ed2fdc14ccbee39542aaeb301f9feaab00547498d0d8a41a&o=&hp=1',
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  snapshot.data.propertyName,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: snapshot
                                                            .data.streetName,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      TextSpan(text: ", "),
                                                      TextSpan(
                                                        text:
                                                            snapshot.data.city,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: 'Id',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(text: ": "),
                                                      TextSpan(
                                                        text: snapshot.data._id,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RatingBar.builder(
                                                  initialRating: _initialRating,
                                                  minRating: 1,
                                                  // direction: _isVertical
                                                  //     ? Axis.vertical
                                                  //     : Axis.horizontal,
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
                                                    _selectedIcon ?? Icons.star,
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
                                                      BorderRadius.circular(10),
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Container(child: Text(),),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // DropdownButton<String>(
                                    //   value: dropdownValue,
                                    //   icon: const Icon(Icons.arrow_downward),
                                    //   elevation: 16,
                                    //   style: const TextStyle(
                                    //       color: Colors.deepPurple),
                                    //   underline: Container(
                                    //     height: 2,
                                    //     color: Colors.deepPurpleAccent,
                                    //   ),
                                    //   onChanged: (String? value) {
                                    //     // This is called when the user selects an item.
                                    //     setState(() {
                                    //       dropdownValue = value!;
                                    //     });
                                    //   },
                                    //   items: list.map<DropdownMenuItem<String>>(
                                    //       (String value) {
                                    //     return DropdownMenuItem<String>(
                                    //       value: value,
                                    //       child: Text(value),
                                    //     );
                                    //   }).toList(),
                                    // ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
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

  Future<List<Hotel>> getHotels() async {
    try {
      // final response =
      // await _dio.get('http://100.22.8.195:3000/users/'); //college
      final response = await _dio.get('http://10.0.2.2:3000/hotel/getHotels/');
      List<Hotel> hotels = [];
      var jsonData = response.data;
      for (var data in jsonData) {
        Hotel hotel = Hotel(
          data['propertyName'],
          data['streetName'],
          data['city'],
          data['_id'],
        );
        hotels.add(hotel);
      }
      return hotels;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }

  Future<Hotel> getHotel(String id) async {
    try {
      // final response =
      // await _dio.get('http://100.22.8.195:3000/users/'); //college
      final response =
          await _dio.get('http://10.0.2.2:3000/hotel/getHotels/$id');

      var jsonData = response.data;

      Hotel hotel = Hotel(
        jsonData['propertyName'],
        jsonData['streetName'],
        jsonData['city'],
        jsonData['_id'],
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
  final String _id;
  Hotel(
    this.propertyName,
    this.streetName,
    this.city,
    this._id,
  );
}
