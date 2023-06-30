import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/config.dart';

final Dio _dio = Dio();

Future<List<Hotel>> searchName(String searchInput) async {
  try {
    final response = await _dio.get('$apiUrl/hotel/search/name/$searchInput',
        options: Options(headers: {'Content-Type': 'application/json'}));

    List<Hotel> hotels = [];
    var jsonData = response.data;
    for (var data in jsonData) {
      Hotel hotel = Hotel(
        data['propertyName'],
        data['city'],
        data['streetName'],
        data['_id'],
      );
      hotels.add(hotel);
    }
    for (var hotel in hotels) {
      print('Property Name: ${hotel.propertyName}');
      print('City: ${hotel.city}');
      print('Street Name: ${hotel.streetName}');
      print('ID: ${hotel._id}');
      print('-------------------');
    }
    return hotels;
  } on DioError catch (e) {
    throw Exception("Error retrieving hotel details: ${e.message}");
  }
}

Future<List<Hotel>> searchCity(String searchInput) async {
  try {
    final response = await _dio.get('$apiUrl/hotel/search/city/$searchInput',
        options: Options(headers: {'Content-Type': 'application/json'}));

    List<Hotel> hotels = [];
    var jsonData = response.data;
    for (var data in jsonData) {
      Hotel hotel = Hotel(
        data['propertyName'],
        data['city'],
        data['streetName'],
        data['_id'],
      );
      hotels.add(hotel);
    }
    for (var hotel in hotels) {
      print('Property Name: ${hotel.propertyName}');
      print('City: ${hotel.city}');
      print('Street Name: ${hotel.streetName}');
      print('ID: ${hotel._id}');
      print('-------------------');
    }
    return hotels;
  } on DioError catch (e) {
    throw Exception("Error retrieving hotel details: ${e.message}");
  }
}

class SearchedHotelsPage extends StatefulWidget {
  @override
  _SearchedHotelsPageState createState() => _SearchedHotelsPageState();
}

class _SearchedHotelsPageState extends State<SearchedHotelsPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String searchInput = arguments['searchInput'] as String;
    final String selectedValue = arguments['selectedValue'] as String;
    final String numberOfNights = arguments['numberOfNights'] as String;
    final String startDate = arguments['startDate'] as String;
    final String endDate = arguments['endDate'] as String;
    final String userId = arguments['userId'] as String;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color.fromARGB(255, 238, 238, 238),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 33,
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'mainPage'),
                ),
              ],
            ),
            body: Container(
              height: double.infinity,
              child: selectedValue == 'home'
                  ? FutureBuilder(
                      future: searchName(searchInput),
                      builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else {
                          final List<Hotel> hotels = snapshot.data!;

                          return ListView.builder(
                              itemCount: hotels.length,
                              itemBuilder: (context, index) {
                                final Hotel hotel = hotels[index];

                                return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 7,
                                    ),
                                    child: Column(children: [
                                      GestureDetector(
                                          onTap: () {
                                            var ID = hotel._id;
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushNamed('hotelInfo',
                                                    arguments: {
                                                  'userId': userId,
                                                  'id': ID,
                                                  'numberOfNights':
                                                      numberOfNights.toString(),
                                                  'startDate': startDate,
                                                  'endDate': endDate
                                                });

                                            print("Specific hotel id: $ID");
                                            print(
                                                "Number of nights: $numberOfNights");
                                            print('homePage');
                                          },
                                          child: Row(children: [
                                            hotelImage(),
                                            // hotelDetails(snapshot.data![index]),
                                            hotelDetails(snapshot, index),
                                          ]))
                                    ]));
                              });
                        }
                      })
                  : FutureBuilder(
                      future: searchCity(searchInput),
                      builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else {
                          final List<Hotel> hotels = snapshot.data!;

                          return ListView.builder(
                              itemCount: hotels.length,
                              itemBuilder: (context, index) {
                                final Hotel hotel = hotels[index];

                                return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      bottom: 7,
                                    ),
                                    child: Column(children: [
                                      GestureDetector(
                                          onTap: () {
                                            var ID = hotel._id;
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushNamed('hotelInfo',
                                                    arguments: {
                                                  'userId': userId,
                                                  'id': ID,
                                                  'numberOfNights':
                                                      numberOfNights.toString(),
                                                  'startDate': startDate,
                                                  'endDate': endDate
                                                });

                                            print("Specific hotel id: $ID");
                                            print(
                                                "Number of nights: $numberOfNights");
                                            print('homePage');
                                          },
                                          child: Row(children: [
                                            hotelImage(),
                                            // hotelDetails(snapshot.data![index]),
                                            hotelDetails(snapshot, index),
                                          ]))
                                    ]));
                              });
                        }
                      }),
            )));
  }
}

Expanded hotelImage() {
  return Expanded(
      flex: 4,
      child: Container(
          height: 100,
          child: Card(
              child:
                  Image.network('https://bit.ly/3KAjXJW', fit: BoxFit.cover))));
}

Expanded hotelDetails(AsyncSnapshot<dynamic> snapshot, int index) {
  return Expanded(
      flex: 6,
      child: Container(
          height: 100,
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                        flex: 5,
                        child: Row(children: [
                          Expanded(
                              child: Text(snapshot.data[index].propertyName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )))
                        ])),
                    SizedBox(height: 7),
                    Expanded(
                        flex: 5,
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            '${snapshot.data[index].streetName}, ${snapshot.data[index].city}',
                          ))
                        ]))
                  ])))));
}

class Hotel {
  final String propertyName;
  final String city;
  final String streetName;
  final String _id;
  Hotel(
    this.propertyName,
    this.city,
    this.streetName,
    this._id,
  );
}
