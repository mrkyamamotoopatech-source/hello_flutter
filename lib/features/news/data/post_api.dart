import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostApi {
  static final _rand = Random();

  /// 外から呼ぶメインの関数
  static Future<List<Post>> fetch(int page) async {
    final dice = _rand.nextInt(3);

    return switch (dice) {
      0 => await _fetchPosts(page),                // 通常：APIから取得
      1 => <Post>[],                           // 空リスト
      _ => throw Exception('デバッグ用に発生させたエラーです'), // エラー
    };
  }

  /// 実際にHTTPを叩く処理
  static Future<List<Post>> _fetchPosts(int page, {int pageSize = 10}) async {
    final skip = page * pageSize;
    final uri = Uri.https(
      'dummyjson.com',
      '/posts',
      {
        'limit': '$pageSize',
        'skip': '$skip',
      },
    );
    final res = await http.get(uri).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final List list = map['posts'] as List;
    return list
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
