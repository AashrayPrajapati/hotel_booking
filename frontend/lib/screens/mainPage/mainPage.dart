import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:hotel_booking/bottomNavs.dart';
// import 'package:get/get.dart';
// import 'package:hotel_booking/home/date_range_picker/date_range_picker.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

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
  // late final _ratingController;
  // late double _rating;

  // double _userRating = 3.0;
  // int _ratingBarMode = 1;
  double _initialRating = 4.5;
  // bool _isRTLMode = false;
  // bool _isVertical = false;

  IconData? _selectedIcon;

  // TextEditingController cityinput = TextEditingController();
  // TextEditingController dateinput = TextEditingController();
  // TextEditingController roominput = TextEditingController();

  TextEditingController dateRangeInput = TextEditingController();

  @override
  void initState() {
    // cityinput.text = "";
    // dateinput.text = "";
    // roominput.text = "";

    dateRangeInput.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[350],
      appBar: AppBar(
        automaticallyImplyLeading: false, // for removing back button in appbar
        centerTitle: true,
        title: Text(
          'yoHotel',
          style: TextStyle(
            backgroundColor: const Color(0x0077b6),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.83,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_outlined),
                          suffixIcon: Icon(Icons.mic_outlined),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: "City or hotels' name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
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
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                            builder: (context, child) {
                              return Theme(
                                  data: ThemeData.dark(), child: child!);
                            },
                          );

                          if (pickedDateRange != null) {
                            print(pickedDateRange);
                            String formattedStartDate = DateFormat('yyyy-MM-dd')
                                .format(pickedDateRange.start);
                            String formattedEndDate = DateFormat('yyyy-MM-dd')
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
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: 'No. of rooms & guests',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.83,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600]),
                        child: Text('Search'),
                        onPressed: () {
                          Navigator.pushNamed(context, 'dashboard');
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
                        "Hotels' lists based on your location",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: EdgeInsets.only(left: 17, right: 17),
                  child: Column(
                    children: [
                      // for (int i = 0; i < 5; i++)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'sunny'),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: 100,
                                  child: Card(
                                    elevation: 7,
                                    child: Image.asset(
                                      "assets/room1.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 100,
                                  child: Card(
                                    elevation: 7,
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Sunny Guest House",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  // Icon(
                                                  //   Icons.favorite_outline,
                                                  //   size: 20,
                                                  // )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Nrs. 4000",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating:
                                                        _initialRating,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Image.asset(
                                    "assets/room2.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Peacock Guest House",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // Icon(
                                                //   Icons.favorite_outline,
                                                //   size: 20,
                                                // )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nrs. 4000",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Image.asset(
                                    "assets/room3.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Hotel Heritage",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // Icon(
                                                //   Icons.favorite_outline,
                                                //   size: 20,
                                                // )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nrs. 4000",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Image.asset(
                                    "assets/room4.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 100,
                                child: Card(
                                  elevation: 7,
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunny Guest House",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // Icon(
                                                //   Icons.favorite_outline,
                                                //   size: 20,
                                                // )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nrs. 4000",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
