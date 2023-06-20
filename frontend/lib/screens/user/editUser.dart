import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';
import 'package:hotel_booking/utils.dart';

// final Dio _dio = Dio();

class User {
  final String name;
  final String email;
  final String password;
  User(
    this.name,
    this.email,
    this.password,
  );
}

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final Dio _dio = Dio();

  Future<User> getUser(String id) async {
    try {
      print('ID from future: $id');
      final response = await _dio.get('$apiUrl/users/$id');

      var jsonData = response.data;

      User userdata = User(
        jsonData['name'] ?? '',
        jsonData['email'] ?? '',
        jsonData['password'] ?? '',
      );

      print('User name: ${userdata.name}'); // Print the name

      return userdata;
    } catch (e) {
      print(e);
      throw Exception("Error retrieving posts: $e");
    }
  }

  void updateUser(
    String name,
    String email,
  ) async {
    final String url = '$apiUrl/users/$ownerId';

    final response = await _dio.patch(
      url,
      data: {
        'name': name,
        'email': email,
      },
    );

    print(response.data);
    if (response.statusCode == 200) {
      print('User Updated');
      // Navigator.pushNamed(context, 'user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'User Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'User Updated Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'user');
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('Error updating user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'User Not Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'User is not updated',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void deleteUser(
    String name,
    String email,
  ) async {
    final String url = '$apiUrl/users/$ownerId';

    final response = await _dio.delete(
      url,
      data: {
        'name': name,
        'email': email,
      },
    );

    print(response.data);
    if (response.statusCode == 200) {
      print('User Deleted');
      // Navigator.pushNamed(context, 'user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'User Deleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'User Deleted Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'user');
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('Error deleting user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'User Not Deleted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'User is not deleted',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void updatePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final String url = '$apiUrl/users/updatePassword/$ownerId';

    final response = await _dio.patch(
      url,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    print(response.data);
    if (response.statusCode == 200) {
      print('Password Updated');
      // Navigator.pushNamed(context, 'user');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Password Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Password Updated Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'user');
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print('Error updating password');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Password Not Updated',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Password is not updated',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    decodeUser();
    print('SUII ID: $ownerId');
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // bool _obscureText = true;
  // bool _obscureText2 = true;

  bool isPasswordMatching = true;

  @override
  Widget build(BuildContext context) {
    Widget buildEditUserWidget(User userData) {
      return ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(
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
                      SizedBox(
                        height: 23,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: TextField(
                          controller: nameController,
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
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 20,
                      //     right: 20,
                      //     bottom: 20,
                      //   ),
                      //   child: TextField(
                      //     controller: passwordController,
                      //     obscureText: _obscureText,
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(17),
                      //       ),
                      //       labelText: 'Old Password',
                      //       suffixIcon: IconButton(
                      //         icon: Icon(
                      //           _obscureText
                      //               ? Icons.visibility
                      //               : Icons.visibility_off,
                      //         ),
                      //         onPressed: () {
                      //           setState(() {
                      //             _obscureText = !_obscureText;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 20,
                      //     right: 20,
                      //     bottom: 20,
                      //   ),
                      //   child: TextField(
                      //     // controller: confirmPasswordController,
                      //     obscureText: _obscureText2,
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(17),
                      //       ),
                      //       labelText: 'New Password',
                      //       suffixIcon: IconButton(
                      //         icon: Icon(
                      //           _obscureText2
                      //               ? Icons.visibility
                      //               : Icons.visibility_off,
                      //         ),
                      //         onPressed: () {
                      //           setState(() {
                      //             _obscureText2 = !_obscureText2;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print('ID: $ownerId');
                                  updateUser(
                                    nameController.text,
                                    emailController.text,
                                  );
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 39, 92, 216),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  minimumSize: Size(130, 50),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('ID: $ownerId');
                                  deleteUser(
                                    nameController.text,
                                    emailController.text,
                                  );
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 200, 62, 57),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  minimumSize: Size(130, 50),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    'changeUserPassword',
                                  );
                                },
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 39, 92, 216),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  minimumSize: Size(130, 50),
                                ),
                              ),
                            ],
                          ),
                        ],
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
        ],
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              updatePassword(
                oldPasswordController.text,
                newPasswordController.text,
                confirmPasswordController.text,
              );
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
        body: FutureBuilder<User>(
          future: getUser(ownerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userData = snapshot.data as User;
              print('User name: ${userData.name}'); // Print the name

              nameController.text = userData.name;
              emailController.text = userData.email;
              // passwordController.text = userData.password;
              // confirmPasswordController.text = userData.password;

              return buildEditUserWidget(userData);
            }
          },
        ),
      ),
    );
  }
}
