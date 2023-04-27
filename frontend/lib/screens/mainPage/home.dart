import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class Home extends StatelessWidget {
  const Home({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController dateRangeInput = TextEditingController();

  @override
  void initState() {
    dateRangeInput.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        scaffoldBackgroundColor: Color.fromARGB(255, 244, 244, 244),
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // for removing back button in appbar
          title: Text('yoHotel'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.83,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_outlined),
                              suffixIcon: Icon(Icons.mic_outlined),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              hintText: "City or hotels' name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 3)),
                      Container(
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.83,
                            child: TextField(
                              readOnly: true,
                              controller: dateRangeInput,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                                hintText: 'Choose dates',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              onTap: () async {
                                DateTimeRange? pickedDateRange =
                                    await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(1937),
                                  lastDate: DateTime(3333),
                                  // dark theme for calendar
                                  // builder: (context, child) {
                                  //   return Theme(data: ThemeData.dark(), child: child!);
                                  // },
                                );

                                if (pickedDateRange != null) {
                                  print(pickedDateRange);
                                  String formattedStartDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDateRange.start);
                                  String formattedEndDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDateRange.end);
                                  String formattedDateRange =
                                      '$formattedStartDate - $formattedEndDate';
                                  print(formattedDateRange);

                                  setState(
                                    () {
                                      dateRangeInput.text = formattedDateRange;
                                    },
                                  );
                                } else {
                                  print("Date range is not selected");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 3)),
                      Container(
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.83,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600]),
                              child: Text('Search'),
                              onPressed: () {
                                // Navigator.pushNamed(context, 'dashboard');
                                // showSearch(
                                //   context: context,
                                //   delegate: MySearchDelegate(),
                                // );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 33),
                      Container(
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              "Popular hotels around your location",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: FutureBuilder(
                            future: getHotels(),
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
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              var ID = snapshot.data[index]._id;

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pushNamed('hotelInfo',
                                                      arguments: ID);
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    height: 100,
                                                    child: Card(
                                                      elevation: 3,
                                                      child: Image.network(
                                                        'https://bit.ly/3KAjXJW',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Container(
                                                    height: 100,
                                                    child: Card(
                                                      elevation: 3,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(7),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 5,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .data[index]
                                                                            .propertyName,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 7,
                                                              ),
                                                              Expanded(
                                                                flex: 5,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: '${snapshot.data[index].streetName}, ${snapshot.data[index].city}',
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Dio _dio = Dio();

  Future<List<Hotel>> getHotels() async {
    try {
      final response = await _dio.get('http://10.0.2.2:3000/hotel/getHotels');

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
      return hotels;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }
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

// class MySearchDelegate extends SearchDelegate {
//   @override
//   Widget? buildLeading(BuildContext context) {
//     IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {},
//     );
//     return null;
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     IconButton(
//       icon: const Icon(Icons.clear),
//       onPressed: () {},
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }
