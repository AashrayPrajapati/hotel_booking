import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => SsecondState();
}

class SsecondState extends State<Second> {
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
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      labelText: "   Property Name",
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
                      labelText: "   Country",
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
                      labelText: "   City",
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
                      labelText: "   Zip/ Postal code",
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
                      labelText: "   Street Name",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'firstRoomCrud');
                      },
                      child: Text("Back"),
                      // style: ButtonStyle(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'thirdRoomCrud');
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
    );
  }
}
