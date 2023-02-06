import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

// GET REQUEST
String url = '';
var response = http.get(url);

// POST REQUEST
// Map<String, String> headers = { 'Content-Type': 'application/json'};
// String json = '{"name": "John", "age": 30}';
// var response = awwait http.post(url, headers: headers, body: json);

final socket = IO.io('http://localhost:3000', <String, dynamic>{
  'transports': ['websocket'],
});
