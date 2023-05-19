import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text(
            'Update Profile',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        // update profile page
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 7,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Center(
                        child: CircleAvatar(
                          // backgroundImage: AssetImage('assets/images/user.png'),
                          radius: 50,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: TextField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: TextField(
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 39, 92, 216),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        minimumSize: Size(130, 50),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
