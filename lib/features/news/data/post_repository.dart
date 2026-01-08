import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../data/settings_repository.dart';

class PostRepository {
  final SettingsRepository _settings;
  final http.Client _client;
  final _rand = Random();

  PostRepository(this._settings, {http.Client? client})
      : _client = client ?? http.Client();

  /// 外から呼ぶメインの関数
  Future<List<Post>> fetch(int page) async {
    final debugNetwork = _settings.getDebugNetwork();
    final pageSize = _settings.getPageSize();
    final dice = (debugNetwork && page == 0)
        ? _rand.nextInt(3)
        : 0;

    return switch (dice) {
      0 => await _fetchPosts(page, pageSize: pageSize), // 通常
      1 => <Post>[], // 空リスト
      _ => throw Exception('デバッグ用に発生させたエラーです'),  // エラー
    };
  }

  /// 実際にHTTPを叩く処理
  Future<List<Post>> _fetchPosts(int page, {required int pageSize}) async {
    final skip = page * pageSize;
    final uri = Uri.https(
      'dummyjson.com',
      '/posts',
      {
        'limit': '$pageSize',
        'skip': '$skip',
      },
    );

    final res =
    await _client.get(uri).timeout(const Duration(seconds: 10));

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
