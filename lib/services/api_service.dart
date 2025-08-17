import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/item.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Item>> fetchItems() async {
    final uri = Uri.parse('$_baseUrl/posts?_limit=25');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch items');
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map(
          (e) => Item(
            id: e['id'] as int,
            title: e['title'] as String,
            description: e['body'] as String,
          ),
        )
        .toList();
  }
}
