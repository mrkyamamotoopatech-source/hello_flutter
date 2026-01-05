import 'package:flutter/material.dart';
import '../data/post_api.dart';
import '../models/post.dart';

class NewsPageViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

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

  Future<void> loadInitial() => _fetch(page: 0, reset: true);

  Future<void> refresh() => _fetch(page: 0, reset: true);

  Future<void> loadMore() async {
    if (!_hasMore || _fetching) return;
    await _fetch(page: _page + 1, reset: false);
  }

  Future<void> _fetch({required int page, required bool reset}) async {
    if (_fetching) return;

    _fetching = true;
    _error = null;

    if (reset) {
      _loading = true;
      _hasMore = true;
      _posts = [];
    } else {
      _loadingMore = true;
    }
    notifyListeners();

    try {
      final result = await PostApi.fetch(page);
      if (reset) {
        _posts = result;
      } else {
        _posts = [..._posts, ...result];
      }
      _page = page;
      _hasMore = result.isNotEmpty;
    } catch (e) {
      if (reset) {
        _error = e.toString();
      }
    } finally {
      _loading = false;
      _loadingMore = false;
      _fetching = false;
      notifyListeners();
    }
  }
}
