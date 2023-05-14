// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisteredUsers extends StatefulWidget {
  const RegisteredUsers({Key? key}) : super(key: key);

  @override
  State<RegisteredUsers> createState() => registerednUsersState();
}

class registerednUsersState extends State<RegisteredUsers> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Logged-in Users',
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Card(
            child: FutureBuilder(
              future: getPosts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(snapshot.data[index].name));
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Post>> getPosts() async {
    try {
      // final response = await _dio.get('http://10.0.2.2:3000/users/');
      final response = await _dio.get('http://100.22.1.130:3000/users/');

      // final response =
      // await _dio.get('http://100.22.8.195:3000/users/'); //college

      List<Post> posts = [];
      var jsonData = response.data;
      for (var p in jsonData) {
        Post post = Post(p['name']);
        posts.add(post);
      }
      return posts;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }
}

class Post {
  final String name;
  Post(this.name);
}
