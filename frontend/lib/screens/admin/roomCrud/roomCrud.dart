import 'package:flutter/material.dart';

class RoomCrud extends StatelessWidget {
  const RoomCrud({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomCrudPage();
  }
}

class RoomCrudPage extends StatefulWidget {
  const RoomCrudPage({super.key});

  @override
  State<RoomCrudPage> createState() => _RoomCrudPageState();
}

class _RoomCrudPageState extends State<RoomCrudPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 154, 255),
          title: Text('Room CRUD'),
          centerTitle: true,
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
