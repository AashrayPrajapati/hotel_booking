import 'package:flutter/material.dart';

class HotelDetails extends StatefulWidget {
  const HotelDetails({super.key});

  @override
  State<HotelDetails> createState() => HhotelDetailsState();
}

class HhotelDetailsState extends State<HotelDetails> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'yoHotel',
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/addHotel.png'),
          //   fit: BoxFit.cover,
          // ),
          // ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hotel Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                        right: 15,
                        left: 15,
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 15,
                          // height: 0.7,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          labelText: "   Check-in time",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15,
                        right: 15,
                        left: 15,
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 15, height: 0.7),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          hintText: "   Check-out time",
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'secondRoomCrud');
                          },
                          child: Text("Back"),
                          // style: ButtonStyle(),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '');
                          },
                          child: Text("Next"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
