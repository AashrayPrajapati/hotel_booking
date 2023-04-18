import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';

class RegisteredHotels extends StatefulWidget {
  const RegisteredHotels({super.key});

  @override
  State<RegisteredHotels> createState() => _RegisteredHotelsState();
}

class Hotel {
  final String propertyName;
  Hotel(this.propertyName);
}

class _RegisteredHotelsState extends State<RegisteredHotels> {
  final Dio _dio = Dio();
  Future<List<Hotel>> getHotels() async {
    try {
      // final response =
      // await _dio.get('http://100.22.8.195:3000/users/'); //college
      final response = await _dio.get('http://10.0.2.2:3000/hotel/getHotels');
      List<Hotel> hotels = [];
      var jsonData = response.data;
      for (var p in jsonData) {
        Hotel hotel = Hotel(p['propertyName']);
        hotels.add(hotel);
      }
      return hotels;
    } on DioError catch (e) {
      throw Exception("Error retrieving posts: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Registered Hotels',
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Card(
            child: FutureBuilder(
              future: getHotels(),
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
                      return ListTile(
                          title: Text(snapshot.data[index].propertyName));
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
}
