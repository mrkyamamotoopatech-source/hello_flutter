import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/features/news/models/post.dart';
import 'package:hello_flutter/features/news/usecase/fetch_posts_use_case.dart';
import 'package:hello_flutter/features/news/view_model/news_page_status.dart';
import 'package:hello_flutter/features/news/view_model/news_page_view_model.dart';

class FakeFetchPostsUseCase implements FetchPostsUseCase {
  FakeFetchPostsUseCase(this._handler);

  final Future<List<Post>> Function(int page) _handler;

  @override
  Future<List<Post>> call(int page) => _handler(page);
}

void main() {
  test('loadInitial updates status and posts', () async {
    final posts = [
      const Post(id: 1, title: 'Hello', body: 'World'),
      const Post(id: 2, title: 'Flutter', body: 'Test'),
    ];
    final useCase = FakeFetchPostsUseCase((page) async {
      expect(page, 0);
      return posts;
    });
    final viewModel = NewsPageViewModel(useCase);

    await viewModel.loadInitial();

    expect(viewModel.status, NewsPageStatus.success);
    expect(viewModel.posts, posts);
    expect(viewModel.page, 0);
  });
}
