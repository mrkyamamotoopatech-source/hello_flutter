import 'package:flutter/material.dart';
import 'package:hello_flutter/features/news/ui/post_detail_page.dart';
import 'package:provider/provider.dart';
import '../view_model/news_page_status.dart';
import '../view_model/news_page_view_model.dart';

class NewsPageBody extends StatefulWidget {
  const NewsPageBody({super.key});

  @override
  State<NewsPageBody> createState() => _NewsPageBodyState();
}

class _NewsPageBodyState extends State<NewsPageBody> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final vm = context.read<NewsPageViewModel>();
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      vm.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsPageViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('News Demo')),
      body: RefreshIndicator(
        onRefresh: () => vm.refresh(),
        child: _buildBody(context, vm),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NewsPageViewModel vm) {
    if (vm.status == NewsPageStatus.initialLoading ||
        (vm.status == NewsPageStatus.refreshing && vm.posts.isEmpty)) {
      return _buildMessageList(
        context,
        const CircularProgressIndicator(),
      );
    }

    if (vm.status == NewsPageStatus.error) {
      return _buildMessageList(
        context,
        Text('読み込みに失敗: ${vm.error}'),
      );
    }

    if (vm.status == NewsPageStatus.empty) {
      return _buildMessageList(
        context,
        const Text('データがありません'),
      );
    }

    // データありのときの本来のリスト
    return ListView.separated(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(), // ← これも付けておくと安心
      itemCount: vm.posts.length + (vm.loadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        if (i >= vm.posts.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final p = vm.posts[i];
        return ListTile(
          leading: Text('${i+1}'),
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
  }

  /// ローディング・エラー・空表示を「スクロール可能」にするための ListView ラッパ
  Widget _buildMessageList(BuildContext context, Widget child) {
    return ListView(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(child: child),
        ),
      ],
    );
  }
}
