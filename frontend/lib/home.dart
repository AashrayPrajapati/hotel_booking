import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 333, left: 112),
            child: Text("You are in the home page\n This is the home page"),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 30),
            child: IconButton(
              icon: Icon(Icons.backspace_rounded),
              // const Text('Escape'),
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
