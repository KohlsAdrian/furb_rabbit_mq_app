import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

String _token = '';

class Rest {
  final _host = 'http://localhost:8080';
  Rest._();
  static final instance = Rest._();

  Future<List<String>> getTopics() async {
    final response = await http.get(
      Uri.parse('$_host/topics'),
      headers: {'Authorization': _token},
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      return (body as List).map((e) => e as String).toList();
    }
    return [];
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_host/login'),
      body: convert.json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final body = convert.json.decode(response.body);
      _token = body['jwt'];
      return true;
    }
    return false;
  }
}
