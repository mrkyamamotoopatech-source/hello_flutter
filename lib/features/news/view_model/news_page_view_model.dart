import 'package:flutter/material.dart';
import '../data/post_repository.dart';
import '../models/post.dart';
import 'news_page_status.dart';

class NewsPageViewModel extends ChangeNotifier {

  final PostRepository _repo;
  NewsPageViewModel(this._repo);

  NewsPageStatus _status = NewsPageStatus.initialLoading;
  NewsPageStatus get status => _status;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  bool _fetching = false;

  String? _error;
  String? get error => _error;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  int _page = 0;
  int get page => _page;

  bool _hasMore = true;

  Future<void> loadInitial() => _fetch(
        page: 0,
        reset: true,
        statusOnStart: NewsPageStatus.initialLoading,
      );

  Future<void> refresh() => _fetch(
        page: 0,
        reset: true,
        statusOnStart: NewsPageStatus.refreshing,
      );

  Future<void> loadMore() async {
    if (!_hasMore || _fetching) return;
    await _fetch(page: _page + 1, reset: false);
  }

  Future<void> _fetch({
    required int page,
    required bool reset,
    NewsPageStatus? statusOnStart,
  }) async {
    if (_fetching) return;

    _fetching = true;
    _error = null;

    if (reset) {
      _status = statusOnStart ?? _status;
      _hasMore = true;
      if (_status == NewsPageStatus.initialLoading) {
        _posts = [];
      }
    } else {
      _loadingMore = true;
    }
    notifyListeners();

    try {
      final result = await _repo.fetch(page);
      if (reset) {
        _posts = result;
      } else {
        _posts = [..._posts, ...result];
      }

      _page = page;
      _hasMore = result.isNotEmpty;

      if (reset) {
        _status =
            result.isEmpty ? NewsPageStatus.empty : NewsPageStatus.success;
      }
    } catch (e) {
      if (reset) {
        _error = e.toString();
        _status = NewsPageStatus.error;
      }
    } finally {
      if (!reset) {
        _loadingMore = false;
      }
      _fetching = false;
      notifyListeners();
    }
  }
}
