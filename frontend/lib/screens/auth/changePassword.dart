import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;

  var role = ['User', 'Hotel Owner'];
  String selectedRole = 'User';

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text('Change new Password'),
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
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(17),
                      topRight: Radius.circular(17),
                    ),
                    child: Container(
                      height: 69,
                      width: double.infinity,
                      color: Color.fromARGB(255, 241, 245, 249),
                      child: Padding(
                        padding: const EdgeInsets.all(19),
                        child: Text('Change Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 71, 85, 105))),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton(
                    elevation: 0,
                    dropdownColor: Colors.grey[200],
                    isExpanded: false,
                    // focusColor: Colors.blue,

                    underline: Container(
                      height: 1,
                      color: Colors.transparent,
                    ),

                    // Initial Value
                    value: selectedRole,

                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.black,
                    ),

                    // Array list of items
                    items: role.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 17, right: 17),
                    child: TextField(
                      controller: newPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        labelText: 'New Password',
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
                        top: 10, bottom: 10, left: 17, right: 17),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        labelText: 'New Password',
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
                    onPressed: () {
                      print(newPasswordController.text);
                      print(confirmPasswordController.text);
                      print('selected role: $selectedRole');
                      // if new password and confirm password are same then update password in database and navigate to login screen
                      if (newPasswordController.text ==
                          confirmPasswordController.text) {
                        // update password in database
                        // navigate to login screen
                        // Navigator.pop(context);
                      } else {
                        // show error message
                        print('Password not matching');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Password not matching',
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                              content: Text('Please enter correct password',
                                  style: TextStyle(fontSize: 17)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(child: Text('OK')),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 43),
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
