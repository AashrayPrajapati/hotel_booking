import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:hotel_booking/config.dart';
import 'package:readmore/readmore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ViewComment extends StatefulWidget {
  const ViewComment({Key? key}) : super(key: key);

  @override
  State<ViewComment> createState() => _ViewCommentState();
}

class Comment {
  final String userName;
  final String comment;
  final String timestamp;

  Comment(this.userName, this.comment, this.timestamp);

  @override
  String toString() {
    return 'User: $userName, Comment: $comment';
  }
}

var hId;
final Dio _dio = Dio();

class _ViewCommentState extends State<ViewComment> {
  String ownerId = '';

  Future<void> jwtDecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedToken = prefs.getString('jwtToken') ?? '';
    String userRole = prefs.getString('role') ?? '';

    // Decode the stored token
    List<String> tokenParts = storedToken.split('.');
    String encodedPayload = tokenParts[1];
    String decodedPayload = utf8.decode(base64Url.decode(encodedPayload));

    // Parse the decoded payload as JSON
    Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);

    // Access the token claims from the payload
    setState(() {
      ownerId = payloadJson['_id'];
    });

    print('UPDATE ROOM PAGE');
    print('Stored Role: $userRole');
    print('USER ID: $ownerId');
  }

  @override
  void initState() {
    super.initState();
    jwtDecode();
  }

  Future<List<Comment>> getComments(String hotelId) async {
    try {
      print(hId);
      List<Comment> comments = [];
      final commentResponse =
          await Dio().get('$apiUrl/comment/getComment/$hotelId');

      var commentData = commentResponse.data;

      for (var data in commentData) {
        Comment comment = Comment(
          data['userName'],
          data['comment'],
          DateFormat('yyyy-MM-dd').format(DateTime.parse(data['timestamp'])),
        );
        comments.add(comment);
      }
      print(comments);
      return comments;
    } on DioError catch (e) {
      throw Exception("Error retrieving comments: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? roomId = arguments['id'] as String?;
    print(roomId);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 246),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'mainPage');
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Color.fromARGB(255, 39, 92, 216),
          title: Text(
            'View Comment',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Comment>>(
          future: getComments(ownerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Data has been successfully fetched
              List<Comment> comments = snapshot.data ?? [];
              if (comments.isEmpty) {
                return Center(child: Text('No comments available'));
              }
              return Column(
                children: List.generate(comments.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.22,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ProfilePicture(
                                  name: comments[index].userName,
                                  radius: 25,
                                  fontsize: 25,
                                  random: true,
                                ),
                                SizedBox(width: 23),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      comments[index].userName,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 38, 38, 38),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      comments[index].timestamp,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 107, 107, 107)
                                                .withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                child: ReadMoreText(comments[index].comment,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                    textAlign: TextAlign.justify,
                                    //
                                    trimLength: 137,
                                    trimMode: TrimMode.Length,
                                    trimCollapsedText: '   Show more',
                                    trimExpandedText: '   Show less',
                                    moreStyle: TextStyle(
                                      color: Colors.blue[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    lessStyle: TextStyle(
                                        color: Colors.blue[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
