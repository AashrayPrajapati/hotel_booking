import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

String ownerId = '';

decodeUser() async {
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
  ownerId = payloadJson['_id'];
  print('Stored Role: $userRole');
  print('USER ID: $ownerId');
  return [ownerId, userRole];
}
