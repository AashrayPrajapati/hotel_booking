import 'package:flutter/material.dart';

// import 'package:dashboard/dashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),

      // theme: ThemeData(
      //   scaffoldBackgroundColor: Color(0xdde4e6),
      // ),
      home: Scaffold(
        // backgroundColor: Colors.grey[350],
        // backgroundColor: Color.fromRGBO(158, 235, 251, 1),
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
            'yoHotel',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Sunny Guest House",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      // color: Colors.silver,
                      // color: Colors.grey[700],

                      color: Color.fromRGBO(113, 112, 110, 1),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Your Dashboard",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(35, 87, 130, 1),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Icon(
                                Icons.input_outlined,
                                size: 50,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "3",
                                    style: TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Check-in",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Icon(
                                Icons.output_outlined,
                                size: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "2",
                                    style: TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Check-out",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // child: Container(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 15)),
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: Icon(
                                Icons.mode_comment_outlined,
                                size: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "7",
                                    style: TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Reviews",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // child: Container(color: Colors.black),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 15)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'roomCrud');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Icon(
                                  Icons.room_preferences,
                                  size: 50,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Text(
                                    "Room CRUD",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Padding(padding: EdgeInsets.only(bottom: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
            ),

            // Below expanded is for bottom navigation bar
            // Expanded(
            //   flex: 1,
            //   child: BottomNav(),
            // ),
          ],
        ),
      ),
    );
  }
}

/*
Hotel name,
Hotel description,
Hotel location,
Contact information
Services,
Room (types rates, images and description)
Room availability
Policies (check-in, check-out time, cancellation policy)
*/
