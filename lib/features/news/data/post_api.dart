import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostApi {
  static Future<List<Post>> fetch() async {
    final uri = Uri.https('dummyjson.com', '/posts');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final List list = map['posts'] as List;
    return list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }
}
