// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Favorite extends StatefulWidget {
//   @override
//   _FavoriteState createState() => _FavoriteState();
// }

// class _FavoriteState extends State<Favorite> {
//   Map<String, dynamic> _todoData = Map();

//   @override
//   void initState() {
//     super.initState();
//     _fetchTodoData();
//   }

//   void _fetchTodoData() async {
//     // final response = await http
//     //     .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
//     final response = await http.get(Uri.parse('http://10.0.2.2:5000/users'));
//     if (response.statusCode == 200) {
//       setState(() {
//         _todoData = jsonDecode(response.body);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Todo'),
//         ),
//         body: Center(
//           child: _todoData.isEmpty
//               ? CircularProgressIndicator()
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Title: ${_todoData['_id']}',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Completed: ${_todoData['name']}',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Api Example'),
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
    ));
  }

  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get('http://10.0.2.2:3000/users/');
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
