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
    final refreshed = PostApi.fetch();
    setState(() {
      _future = refreshed;
    });
    await refreshed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Demo')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Post>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('読み込みに失敗: ${snap.error}'));
            }
            final items = snap.data ?? const <Post>[];
            if (items.isEmpty) return const Center(child: Text('データがありません'));
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  title: Text(p.title),
                  subtitle: Text(p.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PostDetailPage(post: p)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
