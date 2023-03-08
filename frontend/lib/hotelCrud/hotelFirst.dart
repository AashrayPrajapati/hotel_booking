import 'package:flutter/material.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

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
                    controller: _ownerNameController,
                    style: TextStyle(fontSize: 15, height: 0.7),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      labelText: "   Owner Name",
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
                    controller: _emailController,
                    style: TextStyle(fontSize: 15, height: 0.7),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      labelText: "   Enter mail",
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
                    controller: _phoneNumberController,
                    style: TextStyle(fontSize: 15, height: 0.7),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      labelText: "   Phone Number",
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final ownerName = _ownerNameController.text;
                    final email = _emailController.text;
                    final phoneNumber = _phoneNumberController.text;
                    print("Owner Name: $ownerName");
                    print("Email: $email");
                    print("Phone Number: $phoneNumber");

                    Navigator.pushNamed(context, 'secondRoomCrud');
                  },
                  child: Text("Next"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
