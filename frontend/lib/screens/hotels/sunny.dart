import 'package:flutter/material.dart';

class Sunny extends StatelessWidget {
  const Sunny({super.key});

  @override
  Widget build(BuildContext context) {
    return SunnyPage();
  }
}

class SunnyPage extends StatefulWidget {
  const SunnyPage({super.key});

  @override
  State<SunnyPage> createState() => _SunnyPageState();
}

class _SunnyPageState extends State<SunnyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sunny Guest House"),
        centerTitle: true,
        backgroundColor: Colors.blue[500],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  child: SizedBox(
                    child: Container(
                      child: Image.asset(
                        "assets/room1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    child: Container(
                      // width: 50,
                      // height: 50,
                      child: Text('Guest House'),
                    ),
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
