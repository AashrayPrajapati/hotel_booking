import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hotel_booking/config.dart';

class ImageReceiver extends StatefulWidget {
  @override
  _ImageReceiverState createState() => _ImageReceiverState();
}

class _ImageReceiverState extends State<ImageReceiver> {
  String imageUrl = '';

  Future<void> fetchImage() async {
    try {
      var response = await Dio().get(
        '$apiUrl/hotelRoom/image/:id',
      ); // Replace with your API endpoint

      setState(() {
        imageUrl = response.data[
            'url']; // Assuming the response contains the image URL in the 'url' field
      });
    } catch (error) {
      print('Error fetching image: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Receiver'),
        ),
        body: Center(
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
