import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text('Forgot Password'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // backgroundColor: Colors.white.withOpacity(0.93),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(23),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 69,
                    width: double.infinity,
                    color: Color.fromARGB(255, 241, 245, 249),
                    child: Padding(
                      padding: const EdgeInsets.all(19),
                      child: Text('Send OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 71, 85, 105))),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 17, right: 17),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'otp');
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 37),
                      backgroundColor: Color.fromARGB(255, 39, 92, 216),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
