import 'dart:developer';

import 'package:flutter/material.dart';
import '../data/post_api.dart';
import '../models/post.dart';
import 'post_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = PostApi.fetch(); // 初回だけ実行
  }

  Future<void> _refresh() async {
    try {
      final refreshed = PostApi.fetch();

      setState(() {
        _future = refreshed; // FutureBuilder 用の future を更新
      });

      await refreshed; // ← ここでエラーが飛んでくる可能性がある
    } catch (e, st) {
      // ここで握りつぶす or ユーザーに知らせる
      if (!mounted) return;

      // デバッグ用ログ（任意）
      // ignore: avoid_print
      log('refresh failed: $e\n$st');

      // // 画面下にトースト的に出す
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('再読み込みに失敗しました: $e')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Demo'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Post>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              // 読み込み中 → 1個だけ要素を持つ ListView に包む
              return _buildMessageList(
                const CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              // エラー時
              return _buildMessageList(
                Text('読み込みに失敗: ${snap.error}'),
              );
            }

            final items = snap.data ?? const <Post>[];
            if (items.isEmpty) {
              // 空データ時
              return _buildMessageList(
                const Text('データがありません'),
              );
            }

            // 通常（データあり）の ListView
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  title: Text(p.title),
                  subtitle: Text(
                    p.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(post: p),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// ローディング・エラー・空のとき用。
  /// 中身は1つだけだが ListView にしておくことで、
  /// RefreshIndicator がちゃんと「引っ張り」を認識できる。
  Widget _buildMessageList(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(child: child),
        ),
      ],
    );
  }
}
