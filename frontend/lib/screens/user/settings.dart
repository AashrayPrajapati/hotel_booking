import 'package:flutter/material.dart';

class userSettings extends StatelessWidget {
  const userSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/check.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('yoHotel'),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(
                      Icons.question_mark,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'About Us',
                      style: TextStyle(fontSize: 21),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 32,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'v 0.1',
                      style: TextStyle(fontSize: 21),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
